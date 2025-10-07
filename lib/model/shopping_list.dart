import 'product.dart';
import 'package:uuid/uuid.dart';

class ShoppingList {
  final String id;
  String name;
  DateTime createdAt;
  List<Product> items = [];
  double? totalCost;

  ShoppingList({
    String? id,
    required this.name,
    required this.createdAt,
    List<Product>? items,
    this.totalCost,
  }) : id = id ?? const Uuid().v4(),
       items = items ?? [];

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'createdAt': createdAt.toIso8601String(),
    'items': items.map((p) => p.toJson()).toList(),
    'totalCost': totalCost,
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
      totalCost: (json['totalCost'] is num)
          ? (json['totalCost'] as num).toDouble()
          : null,
    );
  }
}
