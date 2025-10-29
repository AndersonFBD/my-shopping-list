import 'package:flutter/material.dart';
import 'package:meu_carrinho/configs/app_config.dart';

class EditListDialog extends StatefulWidget {
  final String initialName;
  final void Function(String newName)? onSave;

  const EditListDialog({super.key, required this.initialName, this.onSave});

  @override
  State<EditListDialog> createState() => _EditListDialogState();
}

class _EditListDialogState extends State<EditListDialog> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
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
            Text('Edite o nome da lista.'),
            const SizedBox(height: 10),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nome',
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConfig().addButtonColor,
                  ),
                  onPressed: () {
                    final newName = _nameController.text.trim();
                    if (newName.isNotEmpty) {
                      widget.onSave?.call(newName);
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    'Salvar',
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
