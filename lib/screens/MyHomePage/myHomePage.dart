import 'package:flutter/material.dart';
import 'package:meu_carrinho/model/product.dart';
import 'package:meu_carrinho/screens/shopList/shopList.dart';

var sabao = product(name: 'sabão', quantity: 3, gotItem: false);

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
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
                      value: sabao.gotItem,
                      onChanged: (bool? value) {
                        setState(() {
                          sabao.gotItem = value!;
                        });
                      },
                    ),
                    title: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Shoplist(),
                          ),
                        );
                      },
                      child: Row(children: [Text(sabao.name)]),
                    ),
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
