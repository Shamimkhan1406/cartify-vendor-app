import 'dart:io';

import 'package:cartify_vendor/controllers/category_controller.dart';
import 'package:cartify_vendor/controllers/product_controller.dart';
import 'package:cartify_vendor/controllers/subcategory_controller.dart';
import 'package:cartify_vendor/models/category.dart';
import 'package:cartify_vendor/models/subcategory.dart';
import 'package:cartify_vendor/provider/vendor_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class UploadScreen extends ConsumerStatefulWidget {
  const UploadScreen({super.key});

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends ConsumerState<UploadScreen> {
  ProductController _productController = ProductController();
  final _formKey = GlobalKey<FormState>();
  late Future<List<Category>> futureCategories;
  Future<List<SubCategory>>? futureSubCategories;
  //late String name;
  Category? selectedCategory;
  SubCategory? selectedSubCategory;
  late String productName;
  late double productPrice;
  late int quantity;
  late String description;

  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureCategories = CategoryController().loadCategories();
  }

  // create an instanse of image picker to handle image picking
  final ImagePicker picker = ImagePicker();
  // initialize a empty list to store selected images
  List<File> images = [];
  // define a function to choose image from gallery
  chooseImage() async {
    // use the picker to choose the image from gallery
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      print('no image is picked');
    } else {
      setState(() {
        images.add(File(pickedFile.path));
      });
    }
  }

  getSubCategoryByCategoryName(value) {
    // fetch subcategory based on category name
    futureSubCategories = SubCategoryController().getSubCategoryByCategoryName(
      value.name,
    );
    selectedSubCategory = null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GridView.builder(
              shrinkWrap: true, // allow the gridview to fit the content
              itemCount: images.length + 1, // +1 grid for the add image button
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                return index == 0
                    ? Center(
                      child: IconButton(
                        onPressed: () {
                          chooseImage();
                        },
                        icon: Icon(Icons.add),
                      ),
                    )
                    : SizedBox(
                      width: 50,
                      height: 50,
                      child: Image.file(images[index - 1]),
                    );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 200,
                    child: TextFormField(
                      onChanged: (value) {
                        productName = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a product name';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Product Name',
                        hintText: 'Enter product name',
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: 200,
                    child: TextFormField(
                      onChanged: (value) {
                        productPrice = double.parse(value);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter product price';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Product Price',
                        hintText: 'Enter product Price',
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: 200,
                    child: TextFormField(
                      onChanged: (value) {
                        quantity = int.parse(value);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter product Quantity';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Product Quantity',
                        hintText: 'Enter product Quantity',
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: 200,
                    child: FutureBuilder(
                      future: futureCategories,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(
                            child: Text('No category available'),
                          );
                        } else {
                          return DropdownButton<Category>(
                            value: selectedCategory,
                            hint: Text('Select Category'),
                            items:
                                snapshot.data!.map((Category category) {
                                  return DropdownMenuItem(
                                    value: category,
                                    child: Text(category.name),
                                  );
                                }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedCategory = value;
                              });
                              getSubCategoryByCategoryName(selectedCategory);
                              print(selectedCategory!.name);
                            },
                          );
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  // data type of futureSubCategories is Future<List<SubCategory>>
                  SizedBox(
                    width: 200,
                    child: FutureBuilder(
                      future: futureSubCategories,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(
                            child: Text('No sub categories available'),
                          );
                        } else {
                          return DropdownButton<SubCategory>(
                            value: selectedSubCategory,
                            hint: Text('Select Sub Category'),
                            items:
                                snapshot.data!.map((SubCategory subcategory) {
                                  return DropdownMenuItem(
                                    value: subcategory,
                                    child: Text(subcategory.subCategoryName),
                                  );
                                }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedSubCategory = value;
                              });
                              print(selectedSubCategory!.subCategoryName);
                            },
                          );
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: 400,
                    child: TextFormField(
                      onChanged: (value) {
                        description = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter product Description';
                        }
                        return null;
                      },
                      maxLines: 3,
                      maxLength: 300,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Product Description',
                        hintText: 'Enter product Description',
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () async {
                  final fullName = ref.read(vendorProvider)!.fullName;
                  final vendorId = ref.read(vendorProvider)!.id;
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      isLoading = true;
                    });
                    await _productController
                        .uploadProduct(
                          productName: productName,
                          productPrice: productPrice,
                          quantity: quantity,
                          description: description,
                          category: selectedCategory!.name,
                          vendorId: vendorId,
                          fullName: fullName,
                          subCategory: selectedSubCategory!.subCategoryName,
                          pickedImages: images,
                          context: context,
                        )
                        .whenComplete(() {
                          setState(() {
                            isLoading = false;
                          });
                          selectedCategory = null;
                          selectedSubCategory = null;
                          images.clear();
                          _formKey.currentState!.reset();
                        });
                  } else {
                    print('please fill all the fields');
                  }
                },
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child:
                        isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                              'Upload Product',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
