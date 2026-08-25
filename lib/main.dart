import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:meu_carrinho/model/shopping_list.dart';
import 'package:meu_carrinho/model/product.dart';
import 'package:meu_carrinho/screens/MyHomePage/myHomePage.dart';
import 'package:meu_carrinho/configs/hive_config.dart';
import 'package:meu_carrinho/repositories/shopping_list_repository.dart';
import 'package:meu_carrinho/widgets/import_list_dialog.dart';

const MethodChannel _importChannel = MethodChannel(
  'meu_carrinho/import_intent',
);

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveConfig.start();

  Hive.registerAdapter(ShoppingListAdapter());
  Hive.registerAdapter(ProductAdapter());

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  final repository = ShoppingListRepository();

  _importChannel.setMethodCallHandler((call) async {
    if (call.method == 'openFile') {
      final filePath = call.arguments as String?;
      if (filePath != null && filePath.isNotEmpty) {
        debugPrint('Intent de importação recebida: $filePath');
        _scheduleImport(repository, filePath);
      }
    }
  });

  final initialFile = await _importChannel.invokeMethod<String>(
    'getInitialFile',
  );
  runApp(
    ChangeNotifierProvider<ShoppingListRepository>.value(
      value: repository,
      child: MyApp(navigatorKey: navigatorKey),
    ),
  );

  if (initialFile != null && initialFile.isNotEmpty) {
    _scheduleImport(repository, initialFile);
  }
}

void _scheduleImport(ShoppingListRepository repository, String filePath) {
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    await repository.initialized;
    _showImportDialog(filePath);
  });
}

void _showImportDialog(String filePath) {
  final context = navigatorKey.currentContext;
  if (context == null) {
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
