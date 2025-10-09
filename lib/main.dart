import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:meu_carrinho/screens/MyHomePage/myHomePage.dart';
import 'package:meu_carrinho/database/hive_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveConfig.start();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((
    _,
  ) {
    runApp(const MyApp());
  });
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
