import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:meu_carrinho/configs/app_config.dart';
import 'package:meu_carrinho/repositories/shopping_list_repository.dart';
import 'package:provider/provider.dart';

class ImportListDialog extends StatefulWidget {
  @override
  _ImportListDialogState createState() => _ImportListDialogState();
}

class _ImportListDialogState extends State<ImportListDialog> {
  String? SelectedFile;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Importar Lista',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            ElevatedButton.icon(
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['mlc'],
                );
                if (result != null && result.files.isNotEmpty) {
                  setState(() {
                    SelectedFile = result.files.single.path!;
                  });
                }
              },
              icon: Icon(Icons.file_open),
              label: Text('Selecionar Arquivo'),
            ),
            const SizedBox(height: 12),
            Text(
              SelectedFile ?? "Nenhum arquivo selecionado",
              style: TextStyle(
                fontSize: 14,
                color: SelectedFile == null ? Colors.grey : Colors.black,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  child: const Text('Cancelar'),
                  onPressed: () => Navigator.pop(context),
                ),

                const SizedBox(width: 8),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConfig().addButtonColor,
                  ),
                  onPressed: SelectedFile == null
                      ? null
                      : () async {
                          final repo = context.read<ShoppingListRepository>();
                          final msg = await repo.importList(SelectedFile!);

                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(msg)));

                          Navigator.of(context).pop();
                        },
                  child: Text(
                    'Importar',
                    style: TextStyle(color: AppConfig().navBarText),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
