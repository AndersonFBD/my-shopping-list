import 'package:uuid/uuid.dart';
import 'package:hive/hive.dart';

part 'product.g.dart';

@HiveType(typeId: 1)
class Product {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  int quantity;

  @HiveField(3)
  String unit;

  @HiveField(4)
  bool gotItem;

  Product({
    String? id,
    required this.name,
    required this.quantity,
    required this.unit,
    this.gotItem = false,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'quantity': quantity,
    "unit": unit,
    "gotItem": gotItem,
  };

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String?,
      name: json['name'] as String? ?? '',
      quantity: (json['quantity'] is num)
          ? (json['quantity'] as num).toInt()
          : int.tryParse('${json['quantity']}') ?? 0,
      unit: json['unit'] as String? ?? '',
      gotItem: json['gotItem'] as bool? ?? false,
    );
  }
}
