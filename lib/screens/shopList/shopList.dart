import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meu_carrinho/configs/app_config.dart';
import 'package:meu_carrinho/model/product.dart';
import 'package:meu_carrinho/repositories/shopping_list_repository.dart';

class Shoplist extends StatefulWidget {
  final String listId;
  const Shoplist({super.key, required this.listId});

  @override
  State<Shoplist> createState() => _ShoplistState();
}

class _ShoplistState extends State<Shoplist> {
  final TextEditingController _productController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<ShoppingListRepository>();
    final list = repo.listas.firstWhere(
      (lista) => lista.id == widget.listId,
      orElse: () => throw Exception("Lista não encontrada"),
    );

    final products = list.items;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConfig().navBarColor,
        title: Text(list.name),
      ),
      body: products.isEmpty
          ? const Center(child: Text('Sua Lista está vazia'))
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  child: ListTile(
                    leading: Checkbox(
                      value: product.gotItem,
                      onChanged: (value) async {
                        await repo.toggleProductCheck(list.id, product);
                      },
                    ),
                    title: Text(
                      product.description,
                      style: TextStyle(
                        decoration: product.gotItem
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    trailing: IconButton(
                      onPressed: () async {
                        await repo.removeProduct(list.id, product);
                      },
                      icon: Icon(Icons.delete),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppConfig().addButtonColor,
        onPressed: () {
          _showAddProductDialog(context, repo, list.id);
        },
        tooltip: 'Adicionar produto',
        child: Icon(Icons.add, color: AppConfig().navBarText),
      ),
    );
  }

  void _showAddProductDialog(
    BuildContext context,
    ShoppingListRepository repo,
    String listId,
  ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('O que quer comprar?'),
        content: TextField(
          controller: _productController,
          decoration: const InputDecoration(
            labelText: 'Descrição',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _productController.clear();
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConfig().addButtonColor,
            ),
            onPressed: () async {
              final desc = _productController.text.trim();
              if (desc.isNotEmpty) {
                final newProduct = Product(description: desc, gotItem: false);
                await repo.addProduct(listId, newProduct);
              }
              Navigator.pop(context);
              _productController.clear();
            },
            child: Text(
              'Adicionar',
              style: TextStyle(color: AppConfig().navBarText),
            ),
          ),
        ],
      ),
    );
  }
}
