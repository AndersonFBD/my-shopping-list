import 'package:uuid/uuid.dart';
import 'package:hive/hive.dart';

part 'product.g.dart';

@HiveType(typeId: 1)
class Product {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String description;

  @HiveField(2)
  bool gotItem;

  Product({String? id, required this.description, this.gotItem = false})
    : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() => {
    'id': id,
    'description': description,
    "gotItem": gotItem,
  };

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String?,
      description: json['description'] as String? ?? '',
      gotItem: json['gotItem'] as bool? ?? false,
    );
  }
}
