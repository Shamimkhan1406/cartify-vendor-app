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
  @override
  Widget build(BuildContext context) {
    final vendor = ref.watch(vendorProvider);
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
      body: const Center(child: Text("Earning Screen")),
    );
  }
}
