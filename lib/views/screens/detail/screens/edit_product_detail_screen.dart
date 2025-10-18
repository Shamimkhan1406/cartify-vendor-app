import 'package:cartify_vendor/models/product.dart';
import 'package:flutter/material.dart';

class EditProductDetailScreen extends StatefulWidget {
  final Product product;

  const EditProductDetailScreen({super.key, required this.product});
  

  @override
  State<EditProductDetailScreen> createState() => _EditProductDetailScreenState();
}

class _EditProductDetailScreenState extends State<EditProductDetailScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _productnameController;
  late TextEditingController _productpriceController;
  late TextEditingController _quantityController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _productnameController = TextEditingController(text: widget.product.productName);
    _productpriceController = TextEditingController(text: widget.product.productPrice.toString());
    _quantityController = TextEditingController(text: widget.product.quantity.toString());
    _descriptionController = TextEditingController(text: widget.product.description);
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
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a product name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _productpriceController,
                decoration: const InputDecoration(
                  labelText: 'Product Price',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a product price';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                ),
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
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
            ],
          ),
        )
      ),
    );
  }
}