import 'package:cartify_vendor/controllers/product_controller.dart';
import 'package:cartify_vendor/provider/vendor_product_provider.dart';
import 'package:cartify_vendor/provider/vendor_provider.dart';
import 'package:cartify_vendor/views/screens/detail/screens/edit_product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

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
    } else {
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
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          MediaQuery.of(context).size.height * 0.2,
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 118,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/icons/cartb.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 322,
                top: 52,
                child: Stack(
                  children: [
                    Image.asset("assets/icons/not.png", width: 25, height: 25),
                    Positioned(
                      top: 0,
                      right: 0,

                      child: Container(
                        height: 20,
                        width: 20,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 250, 201),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            products.length.toString(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 61,
                top: 51,
                child: Text(
                  'Edit Products',
                  style: GoogleFonts.lato(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => EditProductDetailScreen(product: product)));
                },
                child: ListTile(
                  leading: Image.network(
                    product.images[0],
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  title: Text(product.productName,
                      style: GoogleFonts.lato(
                        fontWeight: FontWeight.bold,
                      ),),
                  subtitle: Text(product.category),
                  trailing: Text('₹${product.productPrice.toStringAsFixed(2)}'),
                )
              );
              //ProductItemWidget(product: product);
            },
          ),
    );
  }
}
