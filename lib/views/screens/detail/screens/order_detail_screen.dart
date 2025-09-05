import 'package:cartify_vendor/controllers/order_controller.dart';
import 'package:cartify_vendor/models/order.dart';
import 'package:cartify_vendor/provider/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderDetailScreen extends ConsumerStatefulWidget {
  final Order orders;
  OrderDetailScreen({super.key, required this.orders});

  @override
  ConsumerState<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends ConsumerState<OrderDetailScreen> {
  final OrderController orderController = OrderController();

  @override
  Widget build(BuildContext context) {
    // watch the list of orders to trigger auto ui update
    final orders = ref.watch(orderProvider);
    // final the updated order in the list
    final updatedOrder = orders.firstWhere((o) => o.id == widget.orders.id, orElse: () => widget.orders,);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.orders.productName,
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            height: 1.1,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: 335,
            height: 153,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(),
            child: SizedBox(
              width: double.infinity,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Container(
                      width: 335,
                      height: 153,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color(0xffe0e0e0),
                          width: 1,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x3f000000),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            left: 13,
                            top: 9,
                            child: Container(
                              width: 78,
                              height: 78,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 246, 215, 251),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Positioned(
                                    top: 5,
                                    left: 10,
                                    child: Image.network(
                                      widget.orders.image,
                                      width: 58,
                                      height: 67,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 101,
                            top: 14,

                            child: SizedBox(
                              width: 216,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            width: double.infinity,
                                            child: Text(
                                              widget.orders.productName,
                                              style: GoogleFonts.montserrat(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                height: 1.1,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              widget.orders.category,
                                              style: GoogleFonts.montserrat(
                                                fontSize: 12,
                                                color: const Color(0xff9e9e9e),
                                                height: 1.1,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Align(
                                            alignment: Alignment.centerLeft,

                                            child: Text(
                                              'Quantity: ${widget.orders.quantity}',
                                              style: GoogleFonts.montserrat(
                                                fontSize: 12,
                                                color: const Color(0xff9e9e9e),
                                                height: 1.1,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            '₹${widget.orders.productPrice}',
                                            style: GoogleFonts.montserrat(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              height: 1.1,
                                              color: const Color(0xff4caf50),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 13,
                            top: 113,
                            child: Container(
                              width: 100,
                              height: 25,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                color:
                                    updatedOrder.delivered == true
                                        ? Colors.green
                                        : updatedOrder.processing == true
                                        ? Colors.purpleAccent
                                        : Colors.red,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Positioned(
                                    left: 9,
                                    top: 2,
                                    child: Text(
                                      updatedOrder.delivered == true
                                          ? 'Delivered'
                                          : updatedOrder.processing == true
                                          ? 'Processing'
                                          : 'Cancelled',
                                      style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                        fontSize: 12,
                                        letterSpacing: 1.3,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Positioned(
                          //   top: 115,
                          //   left: 298,
                          //   child: Image.asset(
                          //     'assets/icons/delete.png',
                          //     width: 20,
                          //     height: 20,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // display address
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              width: 336,
              height: 175,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color.fromARGB(255, 168, 137, 255),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Delivery Address',
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '${widget.orders.state} ${widget.orders.city} ${widget.orders.locality}',
                          style: GoogleFonts.lato(
                            fontSize: 16,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'To ${widget.orders.fullName}',
                          style: GoogleFonts.roboto(
                            fontSize: 17,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'Order Id: ${widget.orders.id}',
                          style: GoogleFonts.lato(
                            //fontSize: 17,
                            letterSpacing: 1.5,
                            //fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: updatedOrder.delivered == true ? null : () async {
                            await orderController.updateDeliveryStatus(
                              id: widget.orders.id,
                              context: context,
                            ).whenComplete(
                              (){
                                ref.read(orderProvider.notifier).updateOrderStatus(widget.orders.id, delivered: true);
                              }
                            );
                          },
                          child: Text(
                            updatedOrder.delivered == true ? 'Delivered' : 'Mark as Delivered',
                            style: GoogleFonts.montserrat(
                              fontSize: 10,
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: updatedOrder.processing == false ? null : () async {
                            await orderController.cancelOrder(
                              id: widget.orders.id,
                              context: context,
                            ).whenComplete(
                              (){
                                ref.read(orderProvider.notifier).updateOrderStatus(widget.orders.id, processing: false);
                              }
                            );
                          },
                          child: Text(
                            updatedOrder.processing == false ? "Cancelled" : 'Cancel',
                            style: GoogleFonts.montserrat(
                              fontSize: 10,
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
