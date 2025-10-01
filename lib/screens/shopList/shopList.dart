import 'package:flutter/material.dart';

class Shoplist extends StatelessWidget {
  const Shoplist({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text("Tela da Lista"),
        ),
        body: Center(child: Column()),
      ),
    );
  }
}
