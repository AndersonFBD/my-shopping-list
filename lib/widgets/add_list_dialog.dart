import 'package:flutter/material.dart';
import 'package:meu_carrinho/configs/app_config.dart';

class AddListDialog extends StatefulWidget {
  final void Function(String name)? onAdd;

  const AddListDialog({super.key, this.onAdd});

  @override
  State<AddListDialog> createState() => _AddListDialogState();
}

class _AddListDialogState extends State<AddListDialog> {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // campo de nome
            Text('Adicione uma nova lista.'),
            SizedBox(height: 10),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
                labelText: 'Nome',
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => {Navigator.pop(context)},
                  child: Text('CANCELAR'),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConfig().addButtonColor,
                  ),
                  onPressed: () {
                    final name = _nameController.text.trim();
                    widget.onAdd?.call(name);
                    Navigator.pop(context);
                  },
                  child: Text(
                    'ADICIONAR',
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
