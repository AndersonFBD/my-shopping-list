import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:meu_carrinho/model/shopping_list.dart';
import 'package:meu_carrinho/model/product.dart';
import 'package:meu_carrinho/screens/MyHomePage/myHomePage.dart';
import 'package:meu_carrinho/configs/hive_config.dart';
import 'package:meu_carrinho/repositories/shopping_list_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveConfig.start();

  Hive.registerAdapter(ShoppingListAdapter());
  Hive.registerAdapter(ProductAdapter());

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    ChangeNotifierProvider(
      create: (_) => ShoppingListRepository(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyHomePage(title: 'Minhas listas de compras'),
    );
  }
}
