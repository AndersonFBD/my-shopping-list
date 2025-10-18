import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:meu_carrinho/configs/app_config.dart';
// import 'package:meu_carrinho/model/product.dart';
import 'package:meu_carrinho/model/shopping_list.dart';
import 'package:meu_carrinho/screens/shopList/shopList.dart';
//import 'package:meu_carrinho/storage/file_storage.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
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
        title: Text('Minhas Listas'),
        backgroundColor: Color(0xFF0099FF),
      ),
      body: _listas.isEmpty
          ? const Center(child: Text('Nenhuma lista criada'))
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
        onPressed: () {
          print('botão de adicionar nova lista pressionado');
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
