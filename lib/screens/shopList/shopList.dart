import 'package:flutter/material.dart';
import 'package:meu_carrinho/model/product.dart';

var cafe = Product(name: 'café', quantity: 500, unit: 'gramas');

class Shoplist extends StatefulWidget {
  const Shoplist({super.key});

  @override
  State<Shoplist> createState() => _ShoplistState();
}

class _ShoplistState extends State<Shoplist> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("minha lista"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Column(
              children: [
                Card(
                  child: ListTile(
                    leading: Checkbox(
                      value: cafe.gotItem,
                      onChanged: (bool? value) {
                        setState(() {
                          cafe.gotItem = value!;
                        });
                      },
                    ),
                    title: Text(cafe.name),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('pressionou o botao');
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
