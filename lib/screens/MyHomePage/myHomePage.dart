import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:meu_carrinho/configs/app_config.dart';
import 'package:meu_carrinho/model/shopping_list.dart';
import 'package:meu_carrinho/screens/shopList/shopList.dart';
import '../../widgets/add_list_dialog.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

void _showAddDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (_) => AddListDialog(
      onAdd: (name) {
        if (name.isNotEmpty) {
          print('texto do Dialog: $name');
          Fluttertoast.showToast(
            msg: 'lista adicionada!',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.black.withValues(alpha: 0.7),
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      },
    ),
  );
}

class _MyHomePageState extends State<MyHomePage> {
  bool _loading = true;
  List<ShoppingList> _listas = [];

  @override
  void initState() {
    super.initState();
    _initializeHive();
  }

  Future<void> _initializeHive() async {
    var myListBox = await Hive.openBox<ShoppingList>(
      AppConfig().listaComprasBox,
    );
    final listas = myListBox.values.toList();

    setState(() {
      _listas = listas;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Minhas Listas',
          style: TextStyle(color: AppConfig().navBarText),
        ),
        backgroundColor: AppConfig().navBarColor,
      ),
      body: _listas.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 48.0,
                        color: AppConfig().iconColor,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text('Nenhuma lista criada')],
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _listas.length,
              itemBuilder: (context, index) {
                final lista = _listas[index];
                return ListTile(
                  title: Text('id:${lista.id} | ${lista.name}'),
                  subtitle: Text(
                    'Criada em ${lista.createdAt.day}/${lista.createdAt.month}/${lista.createdAt.year}',
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Shoplist(listId: lista.id),
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppConfig().addButtonColor,
        onPressed: () {
          // Modal para adicionar uma nova lista de compras
          _showAddDialog(context);
        },
        tooltip: 'Nova lista de compras',
        child: Icon(Icons.add, color: AppConfig().navBarText, size: 40.0),
      ),
    );
  }
}
