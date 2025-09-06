import 'package:cartify_vendor/controllers/order_controller.dart';
import 'package:cartify_vendor/provider/order_provider.dart';
import 'package:cartify_vendor/provider/total_earning_provider.dart';
import 'package:cartify_vendor/provider/vendor_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class EarningScreen extends ConsumerStatefulWidget {
  const EarningScreen({super.key});

  @override
  ConsumerState<EarningScreen> createState() => _EarningScreenState();
}

class _EarningScreenState extends ConsumerState<EarningScreen> {
  void initState() {
    super.initState();
    // fetch orders when the screen is initialized
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    final user = ref.read(vendorProvider);
    if (user != null) {
      // fetch orders using the user id
      // final orders = await OrderController().fetchOrders(user.id);
      // update the order provider with the fetched orders
      // ref.read(orderProvider.notifier).setOrders(orders);
      final OrderController orderController = OrderController();
      try {
        final orders = await orderController.loadOrders(vendorId: user.id);
        ref.read(orderProvider.notifier).setOrders(orders);
        ref.read(totalEarningsProvider.notifier).calculateEarnings(orders);
      } catch (e) {
        print('Error fetching orders: $e');
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final vendor = ref.watch(vendorProvider);
    final totalEarnings = ref.watch(totalEarningsProvider);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.purple,
              child: Text(
                vendor!.fullName[0].toUpperCase(),
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 10),
            SizedBox(
              width: 200,
              child: Text('Welcome, ${vendor.fullName}', style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              )),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Total Earnings", style: GoogleFonts.montserrat(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),),
            SizedBox(height: 8),
            Text("₹${totalEarnings.toStringAsFixed(2)}", style: GoogleFonts.montserrat(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),),
          ],
        )),
      ),
    );
  }
}
