import 'dart:ffi';

import 'product.dart';

class ShoppingList {
  String name;
  DateTime createdAt;
  List<product> items = [];
  double? totalCost;

  ShoppingList({
    required this.name,
    required this.createdAt,
    required this.items,
    this.totalCost,
  });
}
