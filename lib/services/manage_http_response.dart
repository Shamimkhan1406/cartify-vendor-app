import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void manageHttpResponse({
  required http.Response response, // the http response from the request
  required BuildContext context, // the context is to show snack bars
  required VoidCallback onSuccess, // the function to call when the request is successful
}){
  // switch statement to handle http status codes
  switch(response.statusCode){
    case 200: // status code 200 means the request was successful
      onSuccess(); // call the onSuccess function
      break;
    case 400: // status code 400 means the request was not successful
      showSnackBar(context, jsonDecode(response.body)['msg']);// show a snackBar with the error message
      break;
    case 500: // status code 500 means server error
      showSnackBar(context, jsonDecode(response.body)['error']);// show a snackBar with the error message
      break;
    case 201: // status code 201 means a resource was created successfully
      onSuccess(); // call the onSuccess function
      break;
    default:
      showSnackBar(context, "Unexpected error: ${response.statusCode}");

  }
}
void showSnackBar(BuildContext context, String message){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}