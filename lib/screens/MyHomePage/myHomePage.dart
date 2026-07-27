import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meu_carrinho/widgets/import_list_dialog.dart';
import 'package:provider/provider.dart';

import 'package:meu_carrinho/configs/app_config.dart';
import 'package:meu_carrinho/model/shopping_list.dart';
import 'package:meu_carrinho/repositories/shopping_list_repository.dart';
import 'package:meu_carrinho/screens/shopList/shopList.dart';
import '../../widgets/add_list_dialog.dart';
import '../../widgets/edit_list_dialog.dart';

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
        actions: [
          IconButton(
            onPressed: () {
              showDialog(context: context, builder: (_) => ImportListDialog());
            },
            icon: Icon(Icons.file_open),
          ),
        ],
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
                  title: Text(lista.name),
                  subtitle: Text(
                    'Criada em ${lista.createdAt.day}/${lista.createdAt.month}/${lista.createdAt.year}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => EditListDialog(
                              initialName: lista.name,
                              onSave: (newName) async {
                                final repo = context
                                    .read<ShoppingListRepository>();
                                lista.name = newName;
                                await repo.updateList(lista);
                              },
                            ),
                          );
                        },
                        icon: Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Remover lista?'),
                              content: Text("deseja remover ${lista.name}?"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(),
                                  child: const Text('CANCELAR'),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  onPressed: () async {
                                    final repo = context
                                        .read<ShoppingListRepository>();
                                    await repo.removeList(lista.id);
                                    Navigator.of(ctx).pop();
                                  },
                                  child: Text('DELETAR'),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: Icon(Icons.delete),
                      ),
                    ],
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
