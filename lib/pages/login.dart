import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_idcard_reader/constants/language.dart';
import 'package:flutter_idcard_reader/futures/show_exit_popup.dart';
import 'package:flutter_idcard_reader/state/user_state.dart';
import 'package:flutter_idcard_reader/themes/colors.dart';
import 'package:flutter_idcard_reader/widgets/btn_language.dart';
import 'package:flutter_idcard_reader/widgets/custom_button.dart';
import 'package:flutter_idcard_reader/widgets/text_form_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/login_model.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  String? _username = '1234567890123';
  String? _password = '0123456789';
  bool _isObscureText = true;

  @override
  void didChangeDependencies() {
    ref.read(userController).init();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final appBar = AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      actions: const [LanguageButtonWidget()],
    );

    final appBarHeight = appBar.preferredSize.height;

    final header = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          translation(context).welcome_title,
          style: theme.textTheme.displaySmall!.merge(
            TextStyle(
              fontWeight: FontWeight.bold,
              color: theme.primaryColor,
            ),
          ),
        ),
        Text(
          translation(context).sign_in_to_continue_title,
          style: theme.textTheme.titleLarge!.merge(
            const TextStyle(
              fontWeight: FontWeight.w500,
              color: textColorSubTitle,
            ),
          ),
        ),
      ],
    );

    final footer = Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        RichText(
          text: TextSpan(
            text: '${translation(context).no_account_label}  ',
            style: theme.textTheme.bodyMedium!.merge(
              const TextStyle(color: textColor),
            ),
            children: [
              TextSpan(
                recognizer: TapGestureRecognizer()
                  ..onTapDown =
                      (details) => Navigator.pushNamed(context, "/register"),
                text: translation(context).btn_sign_up,
                style: theme.textTheme.labelLarge!.merge(
                  TextStyle(
                    fontWeight: FontWeight.w500,
                    color: theme.primaryColor,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        Center(
          child: Text(
            "2022 \u00a9 Kunlanat Pakine",
            style: theme.textTheme.bodyMedium!.merge(
              const TextStyle(color: textColor),
            ),
          ),
        ),
      ],
    );

    return LayoutBuilder(
      builder: (context, constraints) => WillPopScope(
        onWillPop: () => showExitPopup(context),
        child: Scaffold(
          appBar: appBar,
          body: Center(
            child: Container(
              height:
                  (constraints.maxHeight < 853 ? height : 853) - appBarHeight,
              width: constraints.maxWidth < 390 ? width : 390,
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: constraints.maxWidth >= 390 ? 50 : 30,
              ),
              child: Form(
                key: _key,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    header,
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${translation(context).username_title} :',
                          style: theme.textTheme.titleMedium!.merge(
                            const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: textColorTitle,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        FormTextInput(
                          defaultValue: _username,
                          hintText: translation(context).username_hint,
                          onChanged: (value) {
                            setState(() => _username = value);
                          },
                        ),
                        const SizedBox(height: 15),
                        Text(
                          '${translation(context).password_title} :',
                          style: theme.textTheme.titleMedium!.merge(
                            const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: textColorTitle,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        FormTextInput(
                          defaultValue: _password,
                          obscureText: _isObscureText,
                          suffixContent: InkWell(
                            onTap: () {
                              setState(() => _isObscureText = !_isObscureText);
                            },
                            child: const Icon(FluentIcons.eye_16_regular),
                          ),
                          hintText: translation(context).password_hint,
                          onChanged: (value) {
                            setState(() => _password = value);
                          },
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            const Spacer(),
                            CustomTextButtonWidget(
                              text: translation(context).forgot_password,
                              textStyle: theme.textTheme.labelLarge,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    MaterialButton(
                      onPressed: () async {
                        await ref
                            .read(userController)
                            .loginUsers(
                              LoginModel(
                                idcard: '$_username',
                                mobile: '$_password',
                              ),
                            )
                            .then((_) => Navigator.pushNamed(context, "/home"));
                        // Navigator.pushNamed(context, "/home");
                      },
                      minWidth: double.infinity,
                      height: 42,
                      color: theme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        translation(context).btn_sign_in,
                        style: theme.textTheme.titleMedium!
                            .copyWith(color: Colors.white),
                      ),
                    ),
                    const Spacer(),
                    footer,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
