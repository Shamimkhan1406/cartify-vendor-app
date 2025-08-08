// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class product {
  final String id;
  final String productName;
  final double productPrice;
  final int quantity;
  final String description;
  final String category;
  final String subCategory;
  final String images;
  final String vendorId;
  final String fullName;

  product({required this.id, required this.productName, required this.productPrice, required this.quantity, required this.description, required this.category, required this.subCategory, required this.images, required this.vendorId, required this.fullName});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'productName': productName,
      'productPrice': productPrice,
      'quantity': quantity,
      'description': description,
      'category': category,
      'subCategory': subCategory,
      'images': images,
      'vendorId': vendorId,
      'fullName': fullName,
    };
  }

  factory product.fromMap(Map<String, dynamic> map) {
    return product(
      id: map['_id'] as String,
      productName: map['productName'] as String,
      productPrice: map['productPrice'] as double,
      quantity: map['quantity'] as int,
      description: map['description'] as String,
      category: map['category'] as String,
      subCategory: map['subCategory'] as String,
      images: map['images'] as String,
      vendorId: map['vendorId'] as String,
      fullName: map['fullName'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory product.fromJson(String source) => product.fromMap(json.decode(source) as Map<String, dynamic>);
}
