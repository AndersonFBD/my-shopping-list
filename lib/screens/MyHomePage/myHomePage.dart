import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'package:meu_carrinho/configs/app_config.dart';
import 'package:meu_carrinho/model/shopping_list.dart';
import 'package:meu_carrinho/repositories/shopping_list_repository.dart';
import 'package:meu_carrinho/screens/shopList/shopList.dart';
import '../../widgets/add_list_dialog.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

void _showAddDialog(BuildContext outerContext) {
  showDialog(
    context: outerContext,
    barrierDismissible: true,
    builder: (_) => AddListDialog(
      onAdd: (name) async {
        if (name.isNotEmpty) {
          final repo = outerContext.read<ShoppingListRepository>();
          final newList = ShoppingList(
            name: name,
            createdAt: DateTime.now(),
            items: [],
          );

          await repo.addList(newList);

          Fluttertoast.showToast(
            msg: '${newList.name} adicionada!',
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
  List<ShoppingList> listas = [];

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<ShoppingListRepository>();
    final listas = repo.listas;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Minhas Listas',
          style: TextStyle(color: AppConfig().navBarText),
        ),
        backgroundColor: AppConfig().navBarColor,
      ),
      body: listas.isEmpty
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
              itemCount: listas.length,
              itemBuilder: (context, index) {
                final lista = listas[index];
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
