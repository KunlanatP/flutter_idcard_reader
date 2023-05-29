import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_idcard_reader/constants/language.dart';
import 'package:flutter_idcard_reader/pages/home.dart';
import 'package:flutter_idcard_reader/pages/login.dart';
import 'package:flutter_idcard_reader/pages/register.dart';
import 'package:flutter_idcard_reader/pages/setting.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';

import 'services/shared_service.dart';

Widget _detailHome = const LoginPage();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool result = await SharedService.isLoggedIn();
  if (result) {
    _detailHome = const HomePage();
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findRootAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  setLocale(Locale locale) {
    setState(() => _locale = locale);
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) => setLocale(locale));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter ID-Card Reader',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: _locale,
      home: _detailHome,
      // home: IDCardDetailPage(thaiIDCard: mockPeopleData),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/home':
            return PageTransition(
              child: const HomePage(),
              type: PageTransitionType.fade,
              settings: settings,
            );
          case '/login':
            return PageTransition(
              child: const LoginPage(),
              type: PageTransitionType.fade,
              settings: settings,
            );
          case '/register':
            return PageTransition(
              child: const RegisterPage(),
              type: PageTransitionType.fade,
              settings: settings,
            );
          case '/settings':
            return PageTransition(
              child: const SettingPage(),
              type: PageTransitionType.fade,
              settings: settings,
            );
          default:
            return null;
        }
      },
    );
  }
}
