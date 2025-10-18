import 'dart:convert';
import 'dart:io';

import 'package:cartify_vendor/global_variables.dart';
import 'package:cartify_vendor/models/product.dart';
import 'package:cartify_vendor/services/manage_http_response.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProductController {
  Future<void> uploadProduct({
    required String productName,
    required double productPrice,
    required int quantity,
    required String description,
    required String category,
    required String vendorId,
    required String fullName,
    required String subCategory,
    required List<File> pickedImages,
    required context,
  }) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('auth_token');
    try {
      if (pickedImages.isNotEmpty) {
        final cloudinary = CloudinaryPublic(cloudName, uploadPreset);
        List<String> images = [];
        // loop through each image in the pickedImages list
        for (File pickedImage in pickedImages) {
          CloudinaryResponse cloudinaryResponse = await cloudinary.uploadFile(
            CloudinaryFile.fromFile(pickedImage.path, folder: productName),
          );
          // add the secure URL of the uploaded image to the images list
          images.add(cloudinaryResponse.secureUrl);
        }
        print(images);
        if (category.isNotEmpty && subCategory.isNotEmpty) {
          Product product = Product(
            id: '',
            productName: productName,
            productPrice: productPrice,
            quantity: quantity,
            description: description,
            category: category,
            vendorId: vendorId,
            fullName: fullName,
            subCategory: subCategory,
            images: images,
          );
          http.Response response = await http.post(
            Uri.parse("$uri/api/add-product"),
            body: product.toJson(),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'x-auth-token': token!,
            },
          );
          manageHttpResponse(
            response: response,
            context: context,
            onSuccess: () {
              showSnackBar(context, "Product added successfully");
              //Navigator.pop(context);
            },
          );
        } else {
          showSnackBar(context, 'Please select a category and subcategory');
        }
      }
      // Here you would typically send the product data to your backend API
      else {
        showSnackBar(context, 'select at least one image');
      }
    } catch (e) {
      print(e);
    }
  }

  // display related product by subcategory
  Future<List<Product>> loadVendorsProduct(String vendorId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');
      http.Response response = await http.get(
        Uri.parse('$uri/api/products/$vendorId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!,
        },
      );
      // check the http response status code
      if (response.statusCode == 200) {
        // decode the json response body into list of dynamic objects type
        final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;

        // map the list of dynamic objects to a list of Product objects
        List<Product> vendorsProduct =
            data
                .map(
                  (product) => Product.fromMap(product as Map<String, dynamic>),
                )
                .toList();
        return vendorsProduct;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        // if the response status code is not 200, throw an error
        throw Exception('Failed to load vendors Products');
      }
    } catch (e) {
      // Handle error
      throw Exception('Error loading vemdors Products: $e');
    }
  }
  Future<List<String>> uploadImageToCloudinary(List<File>? pickedImages,Product product) async{
    final cloudinary = CloudinaryPublic(cloudName, uploadPreset);
    List<String> uploadedImages = [];
    // loop through each image in the pickedImages list
    for (var image in pickedImages!) {
      CloudinaryResponse cloudinaryResponse = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          image.path,
          folder: product.productName,
        ),
      );
      // add the secure URL of the uploaded image to the images list
      uploadedImages.add(cloudinaryResponse.secureUrl);
    }
    return uploadedImages;

  }
  // update product
  Future<void> updateProduct({
    required Product product,
    required BuildContext context,
    required List<File>? pickedImages,
  }) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('auth_token');
    
    if (pickedImages != null) {
      await uploadImageToCloudinary(pickedImages, product);
    }
    final updatedData = product.toMap();

    http.Response response = await http.put(
      Uri.parse('$uri/api/edit-product/${product.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': token!,
      },
      body: jsonEncode(updatedData),
    );
    manageHttpResponse(response: response, context: context, onSuccess: (){
      showSnackBar(context, 'Product updated successfully');
    });
  }
}
