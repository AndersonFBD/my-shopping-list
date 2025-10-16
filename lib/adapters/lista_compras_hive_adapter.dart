import 'package:hive/hive.dart';
import 'package:meu_carrinho/model/product.dart';
import 'package:meu_carrinho/model/shopping_list.dart';

class ListaComprasHiveAdapter extends TypeAdapter<ShoppingList> {
  @override
  final typeId = 0;

  @override
  ShoppingList read(BinaryReader reader) {
    final id = reader.readString();
    final name = reader.readString();
    final createdAt = reader.read() as DateTime;
    final items = (reader.readList()).cast<Product>();
    return ShoppingList(id: id, name: name, createdAt: createdAt, items: items);
  }

  @override
  void write(BinaryWriter writer, ShoppingList obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.name);
    writer.write(obj.createdAt);
    writer.writeList(obj.items);
  }
}
