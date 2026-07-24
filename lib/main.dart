import 'package:flutter/material.dart';
import 'package:meu_carrinho/screens/MyHomePage/myHomePage.dart';
<<<<<<< Updated upstream
import 'package:flutter/services.dart';
=======
import 'package:meu_carrinho/configs/hive_config.dart';
import 'package:meu_carrinho/repositories/shopping_list_repository.dart';
import 'package:meu_carrinho/widgets/import_list_dialog.dart';

const MethodChannel _importChannel = MethodChannel(
  'meu_carrinho/import_intent',
);
>>>>>>> Stashed changes

void main() {
  WidgetsFlutterBinding.ensureInitialized();
<<<<<<< Updated upstream
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((
    _,
  ) {
    runApp(const MyApp());
  });
=======

  await HiveConfig.start();

  Hive.registerAdapter(ShoppingListAdapter());
  Hive.registerAdapter(ProductAdapter());

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  _importChannel.setMethodCallHandler((call) async {
    if (call.method == 'openFile') {
      final filePath = call.arguments as String?;
      if (filePath != null && filePath.isNotEmpty) {
        debugPrint('Intent de importação recebida: $filePath');
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final context = navigatorKey.currentContext;
          if (context == null || !context.mounted) {
            Future<void>.delayed(const Duration(milliseconds: 300), () {
              _showImportDialog(filePath);
            });
            return;
          }

          _showImportDialog(filePath);
        });
      }
    }
  });

  runApp(
    ChangeNotifierProvider(
      create: (_) => ShoppingListRepository(),
      child: MyApp(navigatorKey: navigatorKey),
    ),
  );
>>>>>>> Stashed changes
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void _showImportDialog(String filePath) {
  final context = navigatorKey.currentContext;
  if (context == null || !context.mounted) {
    return;
  }

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => ImportListDialog(initialFile: filePath),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.navigatorKey});

  final GlobalKey<NavigatorState> navigatorKey;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      home: const MyHomePage(title: 'Minhas listas de compras'),
    );
  }
}
