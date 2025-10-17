import 'product.dart';
import 'package:uuid/uuid.dart';
import 'package:hive/hive.dart';

part 'shopping_list.g.dart';

@HiveType(typeId: 0)
class ShoppingList extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  DateTime createdAt;

  @HiveField(3)
  List<Product> items = [];

  ShoppingList({
    String? id,
    required this.name,
    required this.createdAt,
    required List<Product> items,
  }) : id = id ?? const Uuid().v4(),
       items = items;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'createdAt':
        '${createdAt.year.toString().padLeft(4, '0')}-'
        '${createdAt.month.toString().padLeft(2, '0')}-'
        '${createdAt.day.toString().padLeft(2, '0')}',
    'items': items.map((p) => p.toJson()).toList(),
  };

  factory ShoppingList.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'] as List<dynamic>?;
    return ShoppingList(
      id: json['id'] as String?,
      name: json['name'] as String? ?? '',
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      items: itemsJson != null
          ? itemsJson
                .map((e) => Product.fromJson(e as Map<String, dynamic>))
                .toList()
          : [],
    );
  }
}
