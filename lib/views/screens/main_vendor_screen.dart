import 'package:cartify_vendor/views/screens/nav_screens/earning_screen.dart';
import 'package:cartify_vendor/views/screens/nav_screens/edit_screen.dart';
import 'package:cartify_vendor/views/screens/nav_screens/orders_screen.dart';
import 'package:cartify_vendor/views/screens/nav_screens/upload_screen.dart';
import 'package:cartify_vendor/views/screens/nav_screens/vendor_profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainVendorScreen extends StatefulWidget {
  const MainVendorScreen({super.key});

  @override
  State<MainVendorScreen> createState() => _MainVendorScreenState();
}

class _MainVendorScreenState extends State<MainVendorScreen> {
  int _pageIndex = 0;
  List<Widget> pages = [
    EarningScreen(),
    UploadScreen(),
    EditScreen(),
    OrdersScreen(),
    VendorProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _pageIndex,
        onTap: (value){
          setState(() {
            _pageIndex = value;
          });
        },
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.deepPurple,
        items: [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.money_dollar),
            label: "Earning",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.upload_circle),
            label: "Upload",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: "Edit"),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.shopping_cart),
            label: "Orders",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
      body: pages[_pageIndex],
    );
  }
}
