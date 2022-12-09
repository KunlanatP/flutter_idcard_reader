import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmptyHeader extends StatelessWidget {
  final String? imageUrl;
  final String? text;
  const EmptyHeader({
    this.imageUrl,
    this.text,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imageUrl ?? 'assets/images/smart_card_reader_disconnect.png',
            width: imageUrl != null ? 200 : 128,
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              text ?? 'Empty',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
