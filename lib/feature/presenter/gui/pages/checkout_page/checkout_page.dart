// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:anihan_app/feature/data/models/api/checkout_api.dart';
import 'package:anihan_app/feature/domain/entities/add_to_cart_entity.dart';
import 'package:anihan_app/feature/presenter/gui/pages/checkout_page/cubit/remove_checkout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import '../../../../../common/app_module.dart';
import '../../widgets/checkout_widgets/address_widget.dart';

import '../../widgets/checkout_widgets/items_widget.dart';
import '../../widgets/checkout_widgets/message_to_seller_widget.dart';
import '../../widgets/checkout_widgets/modal/choose_address_modal.dart';
import '../../widgets/checkout_widgets/payment_details_widget.dart';
import '../../widgets/checkout_widgets/payment_method_widget.dart';
import '../../widgets/checkout_widgets/shipping_option_widget.dart';
import '../user_information_bloc/cubit/add_update_user_address_cubit.dart';

class CheckoutPage extends StatefulWidget {
  final String uid;
  // final String storeId;
  final List<AllCartEntity> productEntity;

  const CheckoutPage(
      {super.key, required this.uid, required this.productEntity});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> with CheckoutApi {
  final _addUpdateCubit = getIt<AddUpdateUserAddressCubit>();
  final _removeCheckoutCubit = getIt<RemoveCheckoutCubit>();
  List<String> _listOfAddress = [];
  String _selectedAddress = "";
  final Logger logger = Logger();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  double totalProduct = 0.0;

  @override
  void initState() {
    super.initState();

    setState(() {
      totalProduct = widget.productEntity.fold<double>(
          0.0, // Initial value of the total
          (previousValue, element) =>
              previousValue + calculateTotalPrice(element));
    });

    _addUpdateCubit.getAllTheSavedAddressAndSelectedData(widget.uid);
  }

  _onSectedValue(String? value, StateSetter setState) {
    logger.d(value);
    setState(() {
      _selectedAddress = value ?? "None";
    });

    _addUpdateCubit.updateSelectedAddress(widget.uid, _selectedAddress);
  }

  _onAddAddressFunction() {
    _addUpdateCubit.addUpdateAddress(
        widget.uid, _nameController.text, _nameController.text);
    Navigator.pop(context);
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
      return CheckoutPage(uid: widget.uid, productEntity: widget.productEntity);
    }));
  }

  _onPressedSelectAddress() {
    // Pass the SavedAddressesBloc using BlocProvider.value
    // final savedAddressesBloc = BlocProvider.of<SaveAddressBloc>(context);

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (context) => StatefulBuilder(
              builder: (context, setState) {
                return ChooseAddressModal(
                    nameController: _nameController,
                    onAddAddressFunction: _onAddAddressFunction,
                    listOfAddress: _listOfAddress,
                    onSelectedValue: (String? value) {
                      _onSectedValue(value, setState);
                    },
                    selectedAddress: _selectedAddress);
              },
            ));
  }

  double calculateTotalPrice(AllCartEntity entity) {
    // Calculate total price dynamically for one AllCartEntity
    return entity.productEntity.fold<double>(
      0.0,
      (sum, productMap) {
        productMap.forEach((key, value) {
          final product = value as AddToCartProductEntity;
          sum += product.price *
              product.quantity; // price * quantity for each product
        });
        return sum;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // var data = widget.productEntity;
    // logger.d(data);

    // var data = widget.productEntity.fold(0, initialValue, combine)

    DateTime currentDate = DateTime.now();

    // Add 7 days to the current date
    DateTime futureDate = currentDate.add(Duration(days: 7));

    String formattedDate = DateFormat('MMMM d').format(futureDate);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Theme.of(context).colorScheme.onPrimary),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Checkout"),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            BlocBuilder<AddUpdateUserAddressCubit, AddUpdateUserAddressState>(
              bloc: _addUpdateCubit,
              builder: (context, state) {
                if (state is AllSaveAndSelectedAddressSuccessState) {
                  _listOfAddress = state.data['data'];
                  _selectedAddress = state.data['selectedAddress'];
                }
                return AddressWidget(
                  selectedAddress: _selectedAddress,
                  onPressedSelectAddress: _onPressedSelectAddress,
                );
              },
            ),
            ItemsWidget(
              productEntity: widget.productEntity,
            ),
            MessageToSellerWidget(
              messageController: _messageController,
            ),
            ShippingOptionWidget(
              date: formattedDate,
            ),
            PaymentMethodWidget(),
            PaymentDetailsWidget(
              total: totalProduct,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildPlaceOrderButton(context),
      ),
    );
  }

  Widget _buildPlaceOrderButton(BuildContext context) {
    return InkWell(
      onTap: () async {
        // Placeholder for future functionality
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Order placed successfully!")),
        );

        // Example of saving data directly
        try {
          // Mocked save function
          bool success = await saveCheckoutData(
            productEntity: widget.productEntity,
            total: totalProduct,
            messageToSeller: _messageController.text,
            deliveryDate: DateFormat('MMMM d').format(
              DateTime.now().add(Duration(days: 7)),
            ),
          );

          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Order placed successfully!")),

              //should remove the data on checkout.
              //should minus the quantity of the product.
            );
            for (var data in widget.productEntity) {
              _removeCheckoutCubit.removeCheckout(
                  userId: widget.uid,
                  storeId: data.storeId,
                  cartId: data.cartId);
            }

            Navigator.of(context).pop(); // Return to the previous screen
            Navigator.pop(context); // Return to the previous screen
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Failed to place order.")),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: $e")),
          );
        }
      },
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF43A047), // Green shade for primary start color
              Color(0xFF66BB6A), // Lighter green shade for end color
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            "Place Order",
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ),
    );
  }
}
