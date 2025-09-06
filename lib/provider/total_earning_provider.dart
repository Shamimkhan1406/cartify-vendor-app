
import 'package:cartify_vendor/models/order.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TotalEarningProvider extends StateNotifier<double>{
  // constructor that initializes the state with 0.00
  TotalEarningProvider(): super(0.00);
  // methode to calculate the total earnings based on the deliver status
  void calculateEarnings(List<Order> orders) {
    double earnings = 0.00;
    // loop through all orders in the list of orders
    for (Order order in orders) {
      // check if the deliver
      if (order.delivered){
        earnings += order.productPrice * order.quantity;
      }
      state = earnings;

    }
  }
    
}
 final totalEarningsProvider = StateNotifierProvider<TotalEarningProvider, double>((ref)=> TotalEarningProvider());