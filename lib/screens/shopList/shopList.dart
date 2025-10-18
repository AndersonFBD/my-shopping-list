import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:meu_carrinho/configs/app_config.dart';
import 'package:meu_carrinho/model/shopping_list.dart';

class Shoplist extends StatefulWidget {
  final String listId;
  const Shoplist({super.key, required this.listId});

  @override
  State<Shoplist> createState() => _ShoplistState();
}

class _ShoplistState extends State<Shoplist> {
  late final Box<ShoppingList> _shoppingBox;
  ShoppingList? _currentList;

  @override
  void initState() {
    super.initState();
    _shoppingBox = Hive.box<ShoppingList>(AppConfig().listaComprasBox);
    _currentList = _shoppingBox.get(widget.listId);
  }

  @override
  Widget build(BuildContext context) {
    final products = _currentList?.items ?? [];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(_currentList?.name ?? 'lista'),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            child: ListTile(
              leading: Checkbox(
                value: product.gotItem,
                onChanged: (bool? value) {
                  setState(() {
                    product.gotItem = value ?? false;
                    _currentList!.save();
                  });
                },
              ),
              title: Text(
                "${product.name} (${product.quantity} ${product.unit})",
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('pressionou o botao');
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
