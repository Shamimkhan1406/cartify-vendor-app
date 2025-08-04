import 'package:cartify_vendor/global_variables.dart';
import 'package:cartify_vendor/models/vendor.dart';
import 'package:cartify_vendor/services/manage_http_response.dart';
import 'package:http/http.dart' as http;

class VendorAuthController {
  Future<void> signupVendor({required String fullName, required String email, required String password, required context }) async {

    try {
      Vendor vendor = Vendor(id: '', fullName: fullName, email: email, state: '', city: '', locality: '', role: '', password: password);
      http.Response response = await http.post(Uri.parse("$uri/api/vendor/signin"),
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
}