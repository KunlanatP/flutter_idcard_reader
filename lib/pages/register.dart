import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_idcard_reader/constants/language.dart';
import 'package:flutter_idcard_reader/themes/colors.dart';
import 'package:flutter_idcard_reader/validate/email.dart';
import 'package:flutter_idcard_reader/widgets/btn_language.dart';
import 'package:flutter_idcard_reader/widgets/stepper.dart';
import 'package:flutter_idcard_reader/widgets/text_form_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final header = Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, top: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            translation(context).hi_title,
            style: theme.textTheme.headline3!.merge(
              TextStyle(
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
          ),
          Text(
            translation(context).create_a_new_account_title,
            style: theme.textTheme.headline6!.merge(
              const TextStyle(
                fontWeight: FontWeight.w500,
                color: textColorSubTitle,
              ),
            ),
          ),
        ],
      ),
    );

    final footer = Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, bottom: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          RichText(
            text: TextSpan(
              text: '${translation(context).have_an_account_label}  ',
              style: theme.textTheme.bodyText2!.merge(
                const TextStyle(color: textColor),
              ),
              children: [
                TextSpan(
                  recognizer: TapGestureRecognizer()
                    ..onTapDown = (details) => Navigator.pop(context),
                  text: translation(context).btn_sign_in,
                  style: theme.textTheme.button!.merge(
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
              style: theme.textTheme.bodyText2!.merge(
                const TextStyle(color: textColor),
              ),
            ),
          ),
        ],
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) => Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          actions: const [LanguageButtonWidget()],
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: SizedBox(
            height: constraints.maxHeight < 853 ? height : 853,
            width: constraints.maxWidth < 390 ? width : 390,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                header,
                const Spacer(),
                SizedBox(
                  height: height - (height * 0.45),
                  width: constraints.maxWidth < 390 ? width : 390,
                  child: const RegisterForm(),
                ),
                const Spacer(),
                footer,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  String? emailAddress;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? password;
  String? confirmPassword;

  int currentStep = 0;

  CupertinoStepper _buildStepper() {
    final canCancel = currentStep > 0;
    final canContinue = currentStep < 3;

    return CupertinoStepper(
      type: StepperType.horizontal,
      currentStep: currentStep,
      onStepTapped: (step) => setState(() => currentStep = step),
      onStepCancel: canCancel ? () => setState(() => --currentStep) : null,
      onStepContinue: canContinue
          ? errorTextEmailAddress(emailAddress) != null || emailAddress == null
              ? null
              : () {
                  setState(() => ++currentStep);
                }
          : currentStep == 3
              ? () {}
              : null,
      steps: _getStep,
      controlsBuilder: (context, details) {
        final isLastStep = currentStep == _getStep.length - 1;
        return Container(
          margin: const EdgeInsets.only(top: 50),
          child: currentStep == 0 || isLastStep
              ? ElevatedButton(
                  onPressed: details.onStepContinue,
                  child: Text(isLastStep ? 'CONFIRM' : 'NEXT'),
                )
              : Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: details.onStepCancel,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        child: const Text(
                          'BACK',
                          style: TextStyle(color: textColor),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: details.onStepContinue,
                        child: Text(isLastStep ? 'CONFIRM' : 'NEXT'),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  List<Step> get _getStep {
    final theme = Theme.of(context);
    return [
      _buildStep(
          title: Text(currentStep == 0 ? 'Email' : ''),
          isActive: currentStep == 0,
          state: currentStep == 0
              ? StepState.editing
              : currentStep > 0
                  ? StepState.complete
                  : StepState.indexed,
          content: _buildEmailStep(theme)),
      _buildStep(
        title: Text(currentStep == 1 ? 'Profile' : ''),
        isActive: currentStep == 1,
        state: currentStep == 1
            ? StepState.editing
            : currentStep > 1
                ? StepState.complete
                : StepState.indexed,
        content: _buildProfileStep(theme),
      ),
      _buildStep(
        title: Text(currentStep == 2 ? 'Password' : ''),
        isActive: currentStep == 2,
        state: currentStep == 2
            ? StepState.editing
            : currentStep > 2
                ? StepState.complete
                : StepState.indexed,
        content: _buildPasswordStep(theme),
      ),
      _buildStep(
        title: Text(currentStep == 3 ? 'Complete' : ''),
        isActive: currentStep == 3,
        state: currentStep == 3
            ? StepState.editing
            : currentStep > 3
                ? StepState.complete
                : StepState.indexed,
        content: _buildCompleteStep(theme),
      ),
    ];
  }

  Container _buildCompleteStep(ThemeData theme) {
    return Container(
      color: Colors.blueGrey,
      width: 300,
      height: 200,
      child: const Icon(FluentIcons.add_12_filled),
    );
  }

  SizedBox _buildPasswordStep(ThemeData theme) {
    return SizedBox(
      width: 300,
      height: 200,
      child: Form(
        key: GlobalKey<FormState>(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${translation(context).password_title} :',
              style: theme.textTheme.subtitle1!.merge(
                const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: textColorTitle,
                ),
              ),
            ),
            const SizedBox(height: 5),
            FormTextInput(
              defaultValue: password,
              hintText: translation(context).password_hint,
              onChanged: (value) => setState(() => password = value),
            ),
            const SizedBox(height: 15),
            Text(
              '${translation(context).confirm_password_title} :',
              style: theme.textTheme.subtitle1!.merge(
                const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: textColorTitle,
                ),
              ),
            ),
            const SizedBox(height: 5),
            FormTextInput(
              defaultValue: confirmPassword,
              hintText: translation(context).password_hint,
              onChanged: (value) => setState(() => confirmPassword = value),
            ),
          ],
        ),
      ),
    );
  }

  SizedBox _buildProfileStep(ThemeData theme) {
    return SizedBox(
      width: 300,
      height: 200,
      child: Form(
        key: GlobalKey<FormState>(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${translation(context).firstname_title} :',
              style: theme.textTheme.subtitle1!.merge(
                const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: textColorTitle,
                ),
              ),
            ),
            const SizedBox(height: 5),
            FormTextInput(
              defaultValue: firstName,
              hintText: translation(context).firstname_hint,
              onChanged: (value) => setState(() => firstName = value),
            ),
            const SizedBox(height: 15),
            Text(
              '${translation(context).lastname_title} :',
              style: theme.textTheme.subtitle1!.merge(
                const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: textColorTitle,
                ),
              ),
            ),
            const SizedBox(height: 5),
            FormTextInput(
              defaultValue: lastName,
              hintText: translation(context).lastname_hint,
              onChanged: (value) => setState(() => lastName = value),
            ),
            const SizedBox(height: 15),
            Text(
              '${translation(context).phone_number_title} :',
              style: theme.textTheme.subtitle1!.merge(
                const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: textColorTitle,
                ),
              ),
            ),
            const SizedBox(height: 5),
            FormTextInput(
              defaultValue: phoneNumber,
              hintText: translation(context).phone_number_hint,
              onChanged: (value) => setState(() => phoneNumber = value),
            ),
          ],
        ),
      ),
    );
  }

  SizedBox _buildEmailStep(ThemeData theme) {
    return SizedBox(
      width: 300,
      height: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${translation(context).username_title} :',
            style: theme.textTheme.subtitle1!.merge(
              const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: textColorTitle,
              ),
            ),
          ),
          const SizedBox(height: 5),
          FormTextInput(
            defaultValue: emailAddress,
            errorText: errorTextEmailAddress(emailAddress),
            hintText: translation(context).username_hint,
            onChanged: (value) {
              setState(() {
                emailAddress = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Step _buildStep({
    required Widget title,
    Widget? subtitle,
    StepState state = StepState.indexed,
    bool isActive = false,
    Widget? content,
  }) {
    return Step(
      title: title,
      subtitle: subtitle,
      state: state,
      isActive: isActive,
      content: content ??
          LimitedBox(
            maxWidth: 300,
            maxHeight: 200,
            child: Container(color: CupertinoColors.systemGrey),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildStepper();
  }
}
