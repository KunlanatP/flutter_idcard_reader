import 'package:flutter/material.dart';
import 'package:flutter_idcard_reader/pages/idcard.dart';
import 'package:flutter_idcard_reader/widgets/btn_language.dart';
import 'package:flutter_idcard_reader/widgets/geolocator_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class ReadCardPage extends StatelessWidget {
  const ReadCardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Card Reader',
          style: GoogleFonts.inter(
            color: const Color(0xFF333335),
            fontSize: 21,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Image.asset('assets/images/ship.png'),
        ),
        actions: const [LanguageButtonWidget()],
      ),
      body: const IDCardPage(),
      bottomNavigationBar: const GeolocatorWidget(),
    );
  }
}
