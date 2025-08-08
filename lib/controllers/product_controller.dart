import 'dart:io';

import 'package:cartify_vendor/global_variables.dart';
import 'package:cloudinary_public/cloudinary_public.dart';

class ProductController {
  void uploadProduct({
    required String id,
    required String productName,
    required double productPrice,
    required int quantity,
    required String description,
    required String category,
    required String vendorId,
    required String fullName,
    required String subCategory,
    required List<File> pickedImages,
  }) async{
    try {
      if(pickedImages != null){
        final cloudinary = CloudinaryPublic(cloudName, uploadPreset);
        List <String> images = [];
        // loop through each image in the pickedImages list
        for (File pickedImage in pickedImages) {
          CloudinaryResponse cloudinaryResponse = await cloudinary.uploadFile(CloudinaryFile.fromFile(pickedImage.path, folder: productName),);
          // add the secure URL of the uploaded image to the images list
          images.add(cloudinaryResponse.secureUrl);
        }
        print(images);
      }
      // Here you would typically send the product data to your backend API
    } catch (e) {
      print(e);
    }
  }
}
