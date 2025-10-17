import 'package:cartify_vendor/controllers/product_controller.dart';
import 'package:cartify_vendor/provider/vendor_product_provider.dart';
import 'package:cartify_vendor/provider/vendor_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditScreen extends ConsumerStatefulWidget {
  const EditScreen({super.key});

  @override
  ConsumerState<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends ConsumerState<EditScreen> {
  bool isLoading = true;
  // a Future that will hold the list of popular products
  //late Future<List<Product>> futurePopularProductsFuture;
  @override
  void initState() {
    super.initState();
    //futurePopularProductsFuture = ProductController().loadPopularProducts();
    final products = ref.read(vendorproductProvider);
    if (products.isEmpty) {
     _fetchProducts();
    }
    else{
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchProducts() async {
    final vendor = ref.read(vendorProvider);
    final ProductController productController = ProductController();
    try {
      final products = await productController.loadVendorsProduct(vendor!.id);
      ref.read(vendorproductProvider.notifier).setProducts(products);
    } catch (e) {
      print('Error fetching products: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final products = ref.watch(vendorproductProvider);
    if (products.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Center(child: Text(product.fullName),);
              //ProductItemWidget(product: product);
            },
          ),
        );
  }
}