import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meu_carrinho/configs/app_config.dart';
import 'package:meu_carrinho/repositories/shopping_list_repository.dart';
import 'package:provider/provider.dart';

class ImportListDialog extends StatefulWidget {
  const ImportListDialog({super.key, this.initialFile});

  final String? initialFile;

  @override
  ImportListDialogState createState() => ImportListDialogState();
}

class ImportListDialogState extends State<ImportListDialog> {
  String? selectedFile;
  bool _isImporting = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialFile != null) {
      selectedFile = widget.initialFile;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          debugPrint('Abrindo importação com arquivo: $selectedFile');
          _importSelectedFile();
        }
      });
    }
  }

  Future<void> _importSelectedFile() async {
    if (selectedFile == null || _isImporting) return;

    setState(() => _isImporting = true);

    try {
      final repo = context.read<ShoppingListRepository>();
      final msg = await repo.importList(selectedFile!);
      debugPrint('Resultado da importação: $msg');

      if (!mounted) return;

      Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black.withOpacity(0.7),
        textColor: Colors.white,
        fontSize: 16.0,
      );

      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      Fluttertoast.showToast(
        msg: 'Erro ao importar: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } finally {
      if (mounted) {
        setState(() => _isImporting = false);
      }
    }
  }

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
                FilePickerResult? result = await FilePicker.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['mlc'],
                );
                if (result != null && result.files.isNotEmpty) {
                  setState(() {
                    selectedFile = result.files.single.path!;
                  });
                }
              },
              icon: Icon(Icons.file_open),
              label: Text('Selecionar Arquivo'),
            ),
            const SizedBox(height: 12),
            Text(
              selectedFile ?? "Nenhum arquivo selecionado",
              style: TextStyle(
                fontSize: 14,
                color: selectedFile == null ? Colors.grey : Colors.black,
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
                  onPressed: selectedFile == null || _isImporting
                      ? null
                      : _importSelectedFile,
                  child: Text(
                    _isImporting ? 'Importando...' : 'Importar',
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
