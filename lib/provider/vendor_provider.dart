import 'package:cartify_vendor/models/vendor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// it help to manage the state & designed to notify listners about the state changes
class VendorProvider extends StateNotifier<Vendor?>{
  VendorProvider() :super(Vendor(id: '', fullName: '', email: '', state: '', city: '', locality: '', role: '', password: ''));

  // getter methode to extract the value of the state
  Vendor? get vendor => state;
  // methode to set vendor user state from json 
  // purpose: update the user state based on json String representation of the user vendor object
  void setVendor(String vendoJson){
    state = Vendor.fromJson(vendoJson);
  }
  void signOut(){
    state = null;
  }
}
// make the data available to the rest of the app
final vendorProvider = StateNotifierProvider<VendorProvider, Vendor?>((ref)=> VendorProvider());