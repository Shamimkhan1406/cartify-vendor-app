// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SubCategory {
  final String id;
  final String categoryId;
  final String categoryName;
  final String image;
  final String subCategoryName;

  SubCategory({required this.id, required this.categoryId, required this.categoryName, required this.image, required this.subCategoryName});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'image': image,
      'subCategoryName': subCategoryName,
    };
  }

  String toJson() => json.encode(toMap());

  factory SubCategory.fromJson(Map<String, dynamic> map) {
    return SubCategory(
      id: map['_id'] as String,
      categoryId: map['categoryId'] as String,
      categoryName: map['categoryName'] as String,
      image: map['image'] as String,
      subCategoryName: map['subCategoryName'] as String,
    );
  }



//factory SubCategory.fromJson(String source) => SubCategory.fromMap(json.decode(source) as Map<String, dynamic>);
}
