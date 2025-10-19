
import 'package:cartify_vendor/controllers/vendor_auth_controller.dart';
import 'package:cartify_vendor/provider/vendor_provider.dart';
import 'package:cartify_vendor/views/screens/nav_screens/orders_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class VendorProfileScreen extends ConsumerStatefulWidget {
  VendorProfileScreen({super.key});

  @override
  ConsumerState<VendorProfileScreen> createState() => _VendorProfileScreenState();
}

class _VendorProfileScreenState extends ConsumerState<VendorProfileScreen> {
  final VendorAuthController _vendorAuthController = VendorAuthController();
  // show edit profile dialog
  void _showEditProfileDialog( BuildContext context){
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          
        ),
        title: Text('Edit profile', style: GoogleFonts.montserrat(
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: (){},
              child: CircleAvatar(
                radius: 50,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Icon(CupertinoIcons.photo,size: 24, color: Colors.white,),
                ),
              ),
            ),
            SizedBox(height: 10,),
            TextFormField(
              maxLines: 3,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                labelText: 'Store Description',
                labelStyle: GoogleFonts.montserrat(
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text('Cancel', style: GoogleFonts.montserrat(
            color: Colors.blueGrey,
          ),),),
          ElevatedButton(onPressed: (){}, child: Text('Save', style: GoogleFonts.montserrat(
            color: Colors.green,
          ),),),
        ],
      );
    });
  }
  // show sign out dialog
   void _showSignOutDialog( BuildContext context) {
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),  
        title: Text('Are You Sure?', style: GoogleFonts.montserrat(
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),),
        content: Text('Do you want to sign out?', style: GoogleFonts.montserrat(
          color: Colors.blueGrey,
        ),),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text('No', style: GoogleFonts.montserrat(
            color: Colors.blueGrey,
          ),),),
          TextButton(onPressed: () async {
            await _vendorAuthController.signOutUser(context: context, ref: ref,);
          }, child: Text('Yes', style: GoogleFonts.montserrat(
            color: Colors.red,
          ),),),
        ],
      );
    });
   } 

  @override
  Widget build(BuildContext context) {
    
    
    final user = ref.read(vendorProvider);
    
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 450,
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Image.network(
                      "https://firebasestorage.googleapis.com/v0/b/codeless-app.appspot.com/o/FBrbGWQJqIbpA5ZHEpajYAEh1V93%2Fuploads%2Fimages%2F78dbff80_1dfe_1db2_8fe9_13f5839e17c1_bg2.png?alt=media",
                      width: MediaQuery.of(context).size.width,
                      height: 451,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 30,
                    right: 30,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Image.asset(
                        'assets/icons/not.png',
                        width: 30,
                        height: 30,
                      ),
                    ),
                  ),
                  Stack(
                    children: [
                      Align(
                        alignment: Alignment(0, -0.53),
                        child: CircleAvatar(
                          radius: 65,
                          backgroundImage: NetworkImage(
                            'https://cdn.pixabay.com/photo/2014/04/03/10/32/businessman-310819_1280.png',
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment(0.23, -0.61),
                        child: InkWell(
                          onTap: () {
                            _showEditProfileDialog(context);
                          },
                          child: Image.asset(
                            'assets/icons/edit.png',
                            width: 19,
                            height: 19,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment(0, 0.03),
                    child:
                        user!.fullName != ""
                            ? Text(
                              user.fullName,
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            )
                            : Text(
                              'User',
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                  ),
                  Align(
                    alignment: Alignment(0.05, 0.17),
                    child: InkWell(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => ShippingAddressScreen(),
                        //   ),
                        // );
                      },
                      child:
                          user.state != ""
                              ? Text(
                                user.state,
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                              : Text(
                                'State',
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const OrderScreen();
                    },
                  ),
                );
              },
              leading: Image.asset('assets/icons/orders.png'),
              title: Text(
                'Track your order',
                style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const OrderScreen();
                    },
                  ),
                );
              },
              leading: Image.asset('assets/icons/history.png'),
              title: Text(
                'History',
                style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            ListTile(
              onTap: () {},
              leading: Image.asset('assets/icons/help.png'),
              title: Text(
                'Help',
                style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            ListTile(
              onTap: () {
                _showSignOutDialog(context);
              },
              leading: Image.asset('assets/icons/logout.png'),
              title: Text(
                'Logout',
                style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            ListTile(
              onTap: () async{
                // implement account deletion functionality
                //await authController.deleteAccount(context: context,id: user.id, ref: ref);
              },
              leading: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 9),
                child: Icon(Icons.delete_outline_outlined, color: Colors.red, size: 30,),
              ),
              title: Text(
                'Delete Account',
                style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );

    // Scaffold(
    //   body: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       Center(child: ElevatedButton(onPressed: () async {
    //         await authController.signOutUser(context: context);
    //       }, child: Text("SignOut"))),
    //       ElevatedButton(onPressed: (){
    //         Navigator.push(context, MaterialPageRoute(builder: (context) => OrderScreen()),);
    //       }, child: Text('My Orders'))
    //     ],
    //   ),
    // );
  }
}
