// ignore: depend_on_referenced_packages
import 'package:cartify_vendor/models/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VendorProductProvider extends StateNotifier<List<Product>>{
  VendorProductProvider() : super([]);
  // set the list of products
  void setProducts(List<Product> products){
    state = products;
  }
}

final vendorproductProvider = StateNotifierProvider<VendorProductProvider, List<Product>>((ref) => VendorProductProvider(),);