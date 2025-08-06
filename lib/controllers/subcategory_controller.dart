
import 'package:cartify_vendor/global_variables.dart';
import 'package:cartify_vendor/models/subcategory.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SubCategoryController{
  Future<List<SubCategory>> getSubCategoryByCategoryName(String categoryName) async {
    try{
      http.Response response = await http.get(Uri.parse("$uri/api/categories/$categoryName/subcategories"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if(response.statusCode == 200){
        final decoded = jsonDecode(response.body);
        final List<dynamic> data = decoded is List ? decoded : (decoded['subcategories'] ?? []);
        if (data.isNotEmpty){
          return data.map((subcategory)=> SubCategory.fromJson(subcategory)).toList();
        }
        else{
          print("No subcategories found");
          return [];
        }
      }
      else if(response.statusCode == 404){
        print("No subcategories found for category $categoryName");
        return [];
      }
      else{
        print("Failed to load subcategories: ${response.statusCode}");
        return [];
      }
    }catch(e){
      print("Error loading subcategories: $e");
      return [];
    }
  }
}