import 'package:anihan_app/common/app_module.dart';
import 'package:anihan_app/feature/domain/parameters/farmers_registration_params.dart';
import 'package:anihan_app/feature/presenter/gui/pages/seller_registration_bloc/seller_registration_bloc.dart';
import 'package:anihan_app/feature/presenter/gui/routers/app_routers.dart';
import 'package:anihan_app/feature/presenter/gui/widgets/addons/custom_alert_dialog.dart';
import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

@RoutePage()
class SellerRegistrationPage extends StatefulWidget {
  final String uid;
  final String fullName;
  final int phoneNumber;

  const SellerRegistrationPage(
      {required this.uid,
      required this.fullName,
      required this.phoneNumber,
      Key? key})
      : super(key: key);

  @override
  State<SellerRegistrationPage> createState() => _SellerRegistrationPageState();
}

class _SellerRegistrationPageState extends State<SellerRegistrationPage> {
  final _bloc = getIt<SellerRegistrationBloc>();

  TextEditingController storeNameController = TextEditingController();
  TextEditingController onlineTimeController = TextEditingController();
  TextEditingController storeAddressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final logger = Logger();

  String storeAddress = "";
  String storeName = "";

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return BlocConsumer<SellerRegistrationBloc, SellerRegistrationState>(
      bloc: _bloc,
      listener: (context, state) {
        // TODO: implement listener
        logger.d(state);

        if (state is SellerRegistrationSuccessState) {
          // var data = state.registrationFarmersEntity.
          //

          showDialog(
              context: context,
              builder: (buildContext) {
                return CustomAlertDialog(
                    colorMessage: Colors.greenAccent,
                    onPressedCloseBtn: () {
                      AutoRouter.of(context)
                          .replace(HomeNavigationRoute(uid: widget.uid));
                    },
                    title: "Registration Success",
                    child: Text(
                        "Thank you for Registration. \nYour Store name is $storeName"));
              });
        }
        if (state is SellerErrorState) {
          showDialog(
              context: context,
              builder: (buildContext) {
                return CustomAlertDialog(
                    colorMessage: Colors.greenAccent,
                    onPressOkay: () {
                      Navigator.of(context).pop();
                    },
                    title: "Registration Error",
                    child: const Text(
                        "There's an error occured. Please try again"));
              });
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            child: SizedBox(
              height: _height,
              width: _width,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    children: [
                      Positioned(
                        top: -100,
                        left: -200,
                        child: Transform.rotate(
                          angle: 0.3490,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 2.0,
                            height: 250,
                            color: Colors.green,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -100,
                        right: -200,
                        child: Transform.rotate(
                          angle: 0.3490,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 2.0,
                            height: 250,
                            color: Colors.green,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Column(
                              children: [
                                Image.asset(
                                  'assets/logo.png', // Replace with your actual logo path
                                  height: 100,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Please provide additional\nInformation to become a seller!',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayLarge
                                      ?.copyWith(
                                        fontSize: 20,
                                      ),
                                ),
                                const SizedBox(height: 24),
                              ],
                            ),
                            _buildTextField(
                              context,
                              controller: storeNameController,
                              hintText: 'Store Name',
                              icon: Icons.store,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              context,
                              controller: onlineTimeController,
                              hintText: 'Online Time',
                              icon: Icons.access_time,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              context,
                              controller: storeAddressController,
                              hintText: 'Physical Store/Farm Location',
                              icon: Icons.map,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              context,
                              controller: passwordController,
                              hintText: 'Enter Your Password',
                              icon: Icons.lock,
                              isPassword: true,
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: () {
                                logger.d(storeNameController.text);
                                logger.d(passwordController.text);
                                var params = FarmersRegistrationParams(
                                    storeName: storeNameController.text,
                                    onlineTime: onlineTimeController.text,
                                    storeAddress: storeAddressController.text,
                                    password: passwordController.text);

                                _bloc.add(SellerUidEvent(params));
                              },
                              style:
                                  Theme.of(context).elevatedButtonTheme.style,
                              child: const Text('Finish'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(BuildContext context,
      {required String hintText,
      required IconData icon,
      required TextEditingController controller,
      bool isPassword = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon),
        suffixIcon: isPassword ? const Icon(Icons.visibility_off) : null,
      ),
    );
  }
}
