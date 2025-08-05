import 'dart:convert';

import 'package:cartify_vendor/global_variables.dart';
import 'package:cartify_vendor/models/vendor.dart';
import 'package:cartify_vendor/provider/vendor_provider.dart';
import 'package:cartify_vendor/services/manage_http_response.dart';
import 'package:cartify_vendor/views/screens/main_vendor_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final providerContainer = ProviderContainer();

class VendorAuthController {
  //signup vendor
  Future<void> signupVendor({required String fullName, required String email, required String password, required context }) async {

    try {
      Vendor vendor = Vendor(id: '', fullName: fullName, email: email, state: '', city: '', locality: '', role: '', password: password);
      http.Response response = await http.post(Uri.parse("$uri/api/vendor/signup"),
      body: vendor.toJson(),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      );
      manageHttpResponse(response: response, context: context, onSuccess: (){
        showSnackBar(context, "Vendor signed up successfully");
      });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
  // signin vendor
  Future<void> signinVendor({required String email, required String password, required context}) async{
    try {
      http.Response response = await http.post(Uri.parse("$uri/api/vendor/signin"),
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      );
      manageHttpResponse(response: response, context: context, onSuccess: ()async{
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        String token = jsonDecode(response.body)['token'];
        sharedPreferences.setString('auth_token', token);

        // encode the userdata received from backend
        String vendorJson = jsonEncode(jsonDecode(response.body)['vendor']);
        // update the app state with the user data using reverpod
        providerContainer.read(vendorProvider.notifier).setVendor(vendorJson);
        // store the data in shared preferences
        sharedPreferences.setString('vendor', vendorJson);
        // navigate to the main vendor screen
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainVendorScreen()), (route) => false);
        showSnackBar(context, "Vendor signed in successfully");
      });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}