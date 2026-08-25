import 'package:flutter/material.dart';
import 'package:meu_carrinho/configs/app_config.dart';

class InfoDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Minha Listinha',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text('versão: ${AppConfig().appVersion}'),
            Text('desenvolvido por: ${AppConfig().developerName}'),
            Text(
              'contato: ${AppConfig().contato}',
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
