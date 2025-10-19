import 'dart:convert';
import 'dart:io';

import 'package:cartify_vendor/global_variables.dart';
import 'package:cartify_vendor/models/vendor.dart';
import 'package:cartify_vendor/provider/vendor_provider.dart';
import 'package:cartify_vendor/services/manage_http_response.dart';
import 'package:cartify_vendor/views/screens/authentication/login_screen.dart';
import 'package:cartify_vendor/views/screens/main_vendor_screen.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final providerContainer = ProviderContainer();

class VendorAuthController {
  //signup vendor
  Future<void> signupVendor({
    required String fullName,
    required String email,
    required String password,
    required context,
  }) async {
    try {
      Vendor vendor = Vendor(
        id: '',
        fullName: fullName,
        email: email,
        state: '',
        city: '',
        locality: '',
        role: '',
        password: password,
        token: '',
      );
      http.Response response = await http.post(
        Uri.parse("$uri/api/v2/vendor/signup"),
        body: vendor.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(context, "Vendor signed up successfully");
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // signin vendor
  Future<void> signinVendor({
    required String email,
    required String password,
    required context,
    required WidgetRef ref,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse("$uri/api/v2/vendor/signin"),
        body: jsonEncode({'email': email, 'password': password}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () async {
          // access shared prefferences to save the token and user data storage
          SharedPreferences preferences = await SharedPreferences.getInstance();
          // Extract the authentication token from res body
          String token = jsonDecode(response.body)['token'];
          // strore the auth token in shared preferences
          await preferences.setString("auth_token", token);
          // encode the user data received from the backend as json
          final userJson = jsonEncode(jsonDecode(response.body));
          // update the app state with the user data using reverpod
          ref.read(vendorProvider.notifier).setVendor(response.body);
          // store the user data in shared preferences for future use
          await preferences.setString("user", userJson);

          if (ref.read(vendorProvider)!.token.isNotEmpty) {
            // navigate to the main screen
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => MainVendorScreen()),
              (route) => false,
            );
            // show a snackbar with the message
            showSnackBar(context, "logged in successfully");
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // sign out user
  Future<void> signOutUser({
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    try {
      // access shared prefferences to save the token and user data storage
      SharedPreferences preferences = await SharedPreferences.getInstance();
      // remove the auth token from shared preferences
      await preferences.remove("auth_token");
      // remove the user data from shared preferences
      await preferences.remove("user");
      // clear the app state with the user data using reverpod
      ref.read(vendorProvider.notifier).signOut();
      // navigate to the login screen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false,
      );
      // show a snackbar with the message
      showSnackBar(context, "logged out successfully");
    } catch (e) {
      print('Error during signout: $e');
      showSnackBar(context, "Signout failed: ${e.toString()}");
    }
  }

  // get user data
  getUserData(context, WidgetRef ref) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('auth_token');
      if (token == null) {
        preferences.setString('auth_token', '');
      }
      var tokenResponse = await http.post(
        Uri.parse('$uri/api/vendor/tokenIsValid'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!,
        },
      );
      var response = jsonDecode(tokenResponse.body);
      if (response == true) {
        http.Response userResponse = await http.get(
          Uri.parse('$uri/get-vendor'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token,
          },
        );
        ref.read(vendorProvider.notifier).setVendor(userResponse.body);
      } else {
        showSnackBar(context, "Your login has expired. Please log in again.");
      }
    } catch (e) {
      ///print('Error getting user data: $e');
      showSnackBar(context, "Error getting user data: ${e.toString()}");
    }
  }

  // update user's state city and locality
  Future<void> updateVendorData({
    required BuildContext context,
    required String id,
    required File? storeImage,
    required String storeDescription,
    required WidgetRef ref,
  }) async {
    try {
      final cloudinary = CloudinaryPublic(cloudName, uploadPreset);
      CloudinaryResponse imageResponse = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          storeImage!.path,
          identifier: "pickedImage",
          folder: "storeImage",
        ),
      );
      String image = imageResponse.secureUrl;
      // make a PUT request to update the user location
      http.Response response = await http.put(
        Uri.parse('$uri/api/vendor/$id'),
        // encode the updated data the state city and locality as json
        body: jsonEncode({
          'storeImage': image,
          'storeDescription': storeDescription,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () async {
          final updatedUser = jsonDecode(response.body);
          final userJson = jsonEncode(updatedUser);
          ref.read(vendorProvider.notifier).setVendor(userJson);
          showSnackBar(context, "Vendor data updated successfully");
        },
      );
    } catch (e) {
      print('Error updating Vendor data: $e');
      showSnackBar(context, "vendor data update failed: ${e.toString()}");
    }
  }
}
