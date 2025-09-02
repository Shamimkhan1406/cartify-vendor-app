import 'dart:convert';
import 'package:cartify_vendor/models/order.dart';
import 'package:cartify_vendor/services/manage_http_response.dart';
import 'package:http/http.dart' as http;
import '../global_variables.dart';


class OrderController {
  
  // functions to get orders by vendorId
  Future<List<Order>> loadOrders({required String vendorId}) async{
    try {
      // send http get request to the server
      http.Response response = await http.get(Uri.parse('$uri/api/orders/vendors/$vendorId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      );
    // check if the response is successful
      if (response.statusCode == 200) {
        // parse the response body into dynamic list 
        // this convert the json data into a format that can be used in dart
        List<dynamic> data = jsonDecode(response.body);
        // map the dhynamic list to list of order object using the from json factory method
        // this convert the lis to raw data into list of order object
        List<Order> orders = data.map((order) => Order.fromJson(order)).toList();
        return orders;
      } else {
        // throw an exception if the response is not successful
        throw Exception('Failed to load orders');
      }
    } catch (e) {
      throw Exception('Error loading orders: $e');
    }
  }
  // delete order by id
  Future<void> deleteOrder({required String id, required context}) async{
    try {
      http.Response response = await http.delete(Uri.parse('$uri/api/orders/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      );
      manageHttpResponse(response: response, context: context, onSuccess: (){
        showSnackBar(context, 'Order deleted successfully');
      });
    } catch (e) {
      showSnackBar(context, 'Error deleting order: $e');
      //print('Error deleting order: $e');
    }
  }
}