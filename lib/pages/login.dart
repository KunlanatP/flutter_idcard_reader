import 'package:flutter/material.dart';
import 'package:flutter_idcard_reader/constants/language.dart';
import 'package:flutter_idcard_reader/futures/show_exit_popup.dart';
import 'package:flutter_idcard_reader/themes/colors.dart';
import 'package:flutter_idcard_reader/widgets/custom_button.dart';
import 'package:flutter_idcard_reader/widgets/text_form_field.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  String? username;
  String? password;

  String? get errorTextUsername {
    if (username != null) {
      if (username == '') {
        return 'This field is required.';
      }
      if (RegExp(r'(^\s)|(\s$)').hasMatch(username!)) {
        return 'Shouldn\'t start with a blank. or shouldn\'t end with a space.';
      }
      if (RegExp(r'^[0-9]').hasMatch(username!)) {
        return 'Shouldn\'t start with a number.';
      }
      if (RegExp(r'[ก-ฮ]').hasMatch(username!)) {
        return 'Please use the English language only';
      }
      if (RegExp(r'[^a-zA-Z0-9]').hasMatch(username!)) {
        return 'Cannot use special characters or blank space';
      }
      if (username!.length > 50) {
        return 'Length of text must be between 1-50';
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return LayoutBuilder(
      builder: (context, constraints) {
        return WillPopScope(
          onWillPop: () => showExitPopup(context),
          child: Scaffold(
            body: Center(
              child: Container(
                height: constraints.maxHeight < 853 ? height : 853,
                width: constraints.maxWidth < 390 ? width : 390,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 50,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(translation(context).welcome_title,
                            style: theme.textTheme.headline3!.merge(
                              TextStyle(
                                fontWeight: FontWeight.bold,
                                color: theme.primaryColor,
                              ),
                            )),
                        Text(
                          translation(context).sign_in_to_continue_title,
                          style: theme.textTheme.headline6!.merge(
                            const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: textColorSubTitle,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Form(
                      key: _key,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            translation(context).username_or_email_title,
                            style: theme.textTheme.subtitle1!.merge(
                              const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: textColorTitle,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          CustomTextFormField(
                            defaultValue: username,
                            hintText:
                                translation(context).username_or_email_hint,
                            width: constraints.maxWidth < 390 ? width : 390,
                            onChanged: (value) {
                              setState(() => username = value);
                            },
                          ),
                          const SizedBox(height: 15),
                          Text(
                            translation(context).password_title,
                            style: theme.textTheme.subtitle1!.merge(
                              const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: textColorTitle,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          CustomTextFormField(
                            defaultValue: username,
                            hintText: translation(context).password_hint,
                            width: constraints.maxWidth < 390 ? width : 390,
                            onChanged: (value) {
                              setState(() => password = value);
                            },
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              const Spacer(),
                              CustomTextButton(
                                text: translation(context).forgot_password,
                                textStyle: theme.textTheme.button,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    MaterialButton(
                      onPressed: () async {},
                      minWidth: double.infinity,
                      height: 42,
                      color: theme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        translation(context).btn_sign_in,
                        style: theme.textTheme.subtitle1!
                            .copyWith(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        _divider(),
                        const SizedBox(width: 10),
                        Text(
                          translation(context).or_txt,
                          style: theme.textTheme.headline6!.copyWith(
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(width: 10),
                        _divider(),
                      ],
                    ),
                    const SizedBox(height: 20),
                    CustomButtonWidget(
                      label: translation(context).btn_sign_in_with_facebook,
                      icon: const FaIcon(
                        FontAwesomeIcons.facebook,
                        color: iconFacebookColor,
                      ),
                      onPressed: () {},
                    ),
                    const SizedBox(height: 15),
                    CustomButtonWidget(
                      label: translation(context).btn_sign_in_with_google,
                      icon: const FaIcon(
                        FontAwesomeIcons.googlePlusG,
                        color: iconGoogleColor,
                      ),
                      onPressed: () {},
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          translation(context).no_account_label,
                          style: theme.textTheme.button!
                              .copyWith(fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(width: 15),
                        CustomOnClick(
                          onTap: () =>
                              Navigator.pushNamed(context, "/register"),
                          child: Text(
                            translation(context).btn_sign_up,
                            style: theme.textTheme.button!.copyWith(
                              color: theme.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    const Center(child: Text("2022 \u00a9 Kunlanat Pakine")),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Expanded _divider() {
    return Expanded(
      child: Divider(
        color: Colors.grey.shade300,
        thickness: 1.5,
      ),
    );
  }
}
