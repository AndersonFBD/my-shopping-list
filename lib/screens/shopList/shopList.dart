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
  final FocusNode _focusNode = FocusNode();

  Future<void> _addProduct(BuildContext context) async {
    final name = _productController.text.trim();
    if (name.isEmpty) return;

    final repo = context.read<ShoppingListRepository>();
    final list = repo.listas.firstWhere((lc) => lc.id == widget.listId);

    await repo.addProduct(list.id, Product(description: name));
    _productController.clear();
    _focusNode.requestFocus();
  }

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
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 8,
            right: 8,
            top: 6,
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _productController,
                  focusNode: _focusNode,
                  textInputAction: TextInputAction.send,
                  decoration: InputDecoration(
                    hintText: 'Adicionar produto',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  onSubmitted: (_) => _addProduct(context),
                ),
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                backgroundColor: AppConfig().addButtonColor,
                child: IconButton(
                  onPressed: () => _addProduct(context),
                  icon: Icon(Icons.add, color: Colors.white),
                  tooltip: 'Adicionar',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
