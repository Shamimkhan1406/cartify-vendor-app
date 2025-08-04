import 'dart:convert';

import 'package:cartify_vendor/global_variables.dart';
import 'package:cartify_vendor/models/vendor.dart';
import 'package:cartify_vendor/services/manage_http_response.dart';
import 'package:cartify_vendor/views/screens/main_vendor_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
      manageHttpResponse(response: response, context: context, onSuccess: (){
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainVendorScreen()), (route) => false);
        showSnackBar(context, "Vendor signed in successfully");
      });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}