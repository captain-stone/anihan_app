import 'package:anihan_app/common/app_module.dart';
import 'package:anihan_app/feature/domain/parameters/sign_up_params.dart';
import 'package:anihan_app/feature/presenter/gui/pages/register_bloc/register_page_bloc.dart';
import 'package:anihan_app/feature/presenter/gui/routers/app_routers.dart';
import 'package:anihan_app/feature/presenter/gui/widgets/addons/custom_alert_dialog.dart';
import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

@RoutePage()
class RegistrationFormPage extends StatefulWidget {
  const RegistrationFormPage({super.key});

  @override
  State<RegistrationFormPage> createState() => _RegistrationFormStatePage();
}

class _RegistrationFormStatePage extends State<RegistrationFormPage> {
  final logger = Logger();
  final _regBloc = getIt<RegisterPageBloc>();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailAddressController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    });
  }

  void _registrationMethod() {
    logger.d(phoneNumberController.text);
    logger.d(emailAddressController.text == "");
    bool isNotNull = phoneNumberController.text != "" &&
        emailAddressController.text != "" &&
        fullNameController.text != "";
    bool isEqual = passwordController.text == confirmPasswordController.text;
    logger.d(isEqual);

    if (isNotNull && isEqual) {
      _regBloc.add(GetRegistrationEvent(SignUpParams(
          int.parse(phoneNumberController.text),
          emailAddressController.text,
          fullNameController.text,
          passwordController.text)));
    } else {
      logger.d("Not good");
    }
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return BlocConsumer<RegisterPageBloc, RegisterPageState>(
      bloc: _regBloc,
      listener: (context, state) {
        // TODO: implement listener

        if (state is RegisterFirebaseErrorState) {
          //create a error Message here.
          showDialog(
              context: context,
              builder: (BuildContext builder) => CustomAlertDialog(
                    colorMessage: Colors.red,
                    title: "Verification Error",
                    child: Text(state.message),
                    onPressedCloseBtn: () {
                      Navigator.of(context).pop();
                    },
                  ));
        }

        if (state is RegisteredSuccessState) {
          showDialog(
              context: context,
              builder: (builder) => CustomAlertDialog(
                    colorMessage: Colors.green,
                    title: "Registration Success",
                    height: 80,
                    child: Text(
                        "Thank you, ${state.data.fullName}! You can now explore all the features of the app. Please verify your account to complete the registration process and log in."),
                    onPressedCloseBtn: () {
                      AutoRouter.of(context).push(LoginRoute());
                    },
                  ));
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            child: SizedBox(
              height: _height,
              width: _width,
              child: Stack(
                children: [
                  // Top green rectangle
                  Positioned(
                    top: -100,
                    left: -200,
                    child: Transform.rotate(
                      angle: 0.3490,
                      child: Container(
                        width: _width * 2.0,
                        height: 250,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  // Bottom green rectangle
                  Positioned(
                    bottom: -100,
                    right: -200,
                    child: Transform.rotate(
                      angle: 0.3490,
                      child: Container(
                        width: _width * 2.0,
                        height: 250,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        Image.asset(
                          'assets/logo.png', // Replace with your actual image path
                          height: 100,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Please provide additional Information',
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: phoneNumberController,
                          decoration: const InputDecoration(
                            labelText: 'Phone Number',
                            prefixIcon: const Icon(Icons.phone),
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: emailAddressController,
                          decoration: InputDecoration(
                            labelText: 'Email Address',
                            prefixIcon: Icon(Icons.mail),
                          ),
                          // keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 20),

                        TextField(
                          controller: fullNameController,
                          decoration: InputDecoration(
                            labelText: 'Full Name',
                            prefixIcon: const Icon(Icons.person),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: _togglePasswordVisibility,
                            ),
                          ),
                          obscureText: !_isPasswordVisible,
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: confirmPasswordController,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isConfirmPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: _toggleConfirmPasswordVisibility,
                            ),
                          ),
                          obscureText: !_isConfirmPasswordVisible,
                        ),
                        const SizedBox(height: 30),

                        //THIS IS WHERE YOU SIGNIN *******************
                        ElevatedButton(
                          onPressed: _registrationMethod,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                          ).merge(Theme.of(context).elevatedButtonTheme.style),
                          child: Text(
                            'Finish',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
