import 'dart:io';

import 'package:cartify_vendor/controllers/product_controller.dart';
import 'package:cartify_vendor/models/product.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProductDetailScreen extends StatefulWidget {
  final Product product;

  const EditProductDetailScreen({super.key, required this.product});

  @override
  State<EditProductDetailScreen> createState() =>
      _EditProductDetailScreenState();
}

class _EditProductDetailScreenState extends State<EditProductDetailScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ProductController _productController = ProductController();
  late TextEditingController _productnameController;
  late TextEditingController _productpriceController;
  late TextEditingController _quantityController;
  late TextEditingController _descriptionController;

  List<File> pickedImages = [];

  @override
  void initState() {
    super.initState();
    _productnameController = TextEditingController(
      text: widget.product.productName,
    );
    _productpriceController = TextEditingController(
      text: widget.product.productPrice.toString(),
    );
    _quantityController = TextEditingController(
      text: widget.product.quantity.toString(),
    );
    _descriptionController = TextEditingController(
      text: widget.product.description,
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickMultiImage();
    setState(() {
      pickedImages = pickedFile.map((file) => File(file.path)).toList();
    });
  }

  Future<void> _updateProduct() async {
    if (_formKey.currentState!.validate()) {
      // upload images if selected
      List<String> uploadImages =
          pickedImages.isNotEmpty
              ? await _productController.uploadImageToCloudinary(
                pickedImages,
                widget.product,
              )
              : widget.product.images;
      // create an instance of product model
      final updatedProduct = Product(
        id: widget.product.id,
        productName: _productnameController.text,
        productPrice: double.parse(_productpriceController.text),
        quantity: int.parse(_quantityController.text),
        description: _descriptionController.text,
        images: pickedImages.isNotEmpty ? uploadImages : widget.product.images,
        category: widget.product.category,
        subCategory: widget.product.subCategory,
        vendorId: widget.product.vendorId,
        fullName: widget.product.fullName,
        avgRating: widget.product.avgRating,
        totalRating: widget.product.totalRating,
      );
      await _productController.updateProduct(
        product: updatedProduct,
        context: context,
        pickedImages: pickedImages,
      );
    } else {
      print("Form is not valid");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: _productnameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a product name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _productpriceController,
                decoration: const InputDecoration(labelText: 'Product Price'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a product price';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Quantity'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a quantity';
                  }
                  return null;
                },
              ),
              TextFormField(
                maxLength: 500,
                maxLines: 5,
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              // display current product images
              if (widget.product.images.isNotEmpty)
                Wrap(
                  spacing: 10,
                  children:
                      widget.product.images
                          .map(
                            (imageUrl) => InkWell(
                              onTap: () {
                                _pickImage();
                              },
                              child: Image.network(
                                imageUrl,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                          .toList(),
                ),
              SizedBox(height: 10),
              // display picked images
              if (pickedImages.isNotEmpty) const Text('Picked Images'),
              Wrap(
                spacing: 10,
                children:
                    pickedImages
                        .map(
                          (image) => Image.file(
                            image,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        )
                        .toList(),
              ),
              // display upload button
              ElevatedButton(
                onPressed: () {
                  _updateProduct();
                },
                child: const Text("Update Product"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
