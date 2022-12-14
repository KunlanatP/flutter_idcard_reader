import 'package:flutter/material.dart';
import 'package:flutter_idcard_reader/constants/language.dart';
import 'package:flutter_idcard_reader/widgets/btn_language.dart';
import 'package:flutter_idcard_reader/widgets/custom_button.dart';
import 'package:flutter_idcard_reader/widgets/geolocator_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final appBar = AppBar(
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
    );

    final appBarHeight = appBar.preferredSize.height;

    return LayoutBuilder(
      builder: (context, constraints) => Scaffold(
        appBar: appBar,
        body: Center(
          child: Container(
            height: (constraints.maxHeight < 853 ? height : 853) - appBarHeight,
            width: constraints.maxWidth < 390 ? width : 390,
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: constraints.maxWidth >= 390 ? 50 : 30,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButtonWidget(
                  label: translation(context).btn_read,
                  labelStyle:
                      theme.textTheme.subtitle1!.copyWith(color: Colors.white),
                  color: theme.primaryColor,
                  onPressed: () => Navigator.pushNamed(context, "/read-card"),
                ),
                const SizedBox(height: 15),
                CustomButtonWidget(
                  label: translation(context).btn_setting,
                  onPressed: () => Navigator.pushNamed(context, "/settings"),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const GeolocatorWidget(),
      ),
    );
  }
}
