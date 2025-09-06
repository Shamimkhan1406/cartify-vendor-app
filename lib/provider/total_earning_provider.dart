
import 'package:cartify_vendor/models/order.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TotalEarningProvider extends StateNotifier<Map<String, dynamic>>{
  // constructor that initializes the state with 0.00
  TotalEarningProvider(): super({
    'earnings': 0.00,
    'orderCount': 0
  });
  // methode to calculate the total earnings based on the deliver status
  void calculateEarnings(List<Order> orders) {
    double earnings = 0.00;
    int orderCount = 0;
    // loop through all orders in the list of orders
    for (Order order in orders) {
      // check if the deliver
      if (order.delivered){
        orderCount++;
        earnings += order.productPrice * order.quantity;
      }
      state = {
        'earnings': earnings,
        'orderCount': orderCount
      };

    }
  }
    
}
 final totalEarningsProvider = StateNotifierProvider<TotalEarningProvider, Map<String, dynamic>>((ref)=> TotalEarningProvider());