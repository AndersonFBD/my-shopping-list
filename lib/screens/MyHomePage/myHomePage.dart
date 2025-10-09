import 'package:flutter/material.dart';
import 'package:meu_carrinho/model/product.dart';
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

  @override
  void initState() {
    super.initState();
    _initializeFile();
  }

  Future<void> _initializeFile() async {
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(body: Center(child: Text('Arquivo carregado.')));
  }
}
