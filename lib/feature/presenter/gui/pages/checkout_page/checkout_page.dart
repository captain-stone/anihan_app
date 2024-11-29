// ignore_for_file: prefer_const_constructors

import 'package:anihan_app/feature/data/models/api/checkout_api.dart';
import 'package:anihan_app/feature/domain/entities/add_to_cart_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../widgets/checkout_widgets/address_widget.dart';
import '../../widgets/checkout_widgets/bloc/saved_address_bloc.dart';
import '../../widgets/checkout_widgets/items_widget.dart';
import '../../widgets/checkout_widgets/message_to_seller_widget.dart';
import '../../widgets/checkout_widgets/payment_details_widget.dart';
import '../../widgets/checkout_widgets/payment_method_widget.dart';
import '../../widgets/checkout_widgets/shipping_option_widget.dart';

class CheckoutPage extends StatelessWidget with CheckoutApi {
  final List<AddToCartEntity> productEntity;

  CheckoutPage({super.key, required this.productEntity});

  @override
  Widget build(BuildContext context) {
    var totalProduct = productEntity.fold<double>(
      0.0, // Initial value of the total
      (previousValue, element) => previousValue + element.totalPrice,
    );

    DateTime currentDate = DateTime.now();

    // Add 7 days to the current date
    DateTime futureDate = currentDate.add(Duration(days: 7));

    String formattedDate = DateFormat('MMMM d').format(futureDate);

    return BlocProvider(
      create: (context) => SavedAddressesBloc(),
      child: Scaffold(
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
              const AddressWidget(),
              ItemsWidget(
                productEntity: productEntity,
              ),
              MessageToSellerWidget(),
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
            productEntity: productEntity,
            total: productEntity.fold<double>(
              0.0,
              (previousValue, element) => previousValue + element.totalPrice,
            ),
            deliveryDate: DateFormat('MMMM d').format(
              DateTime.now().add(Duration(days: 7)),
            ),
          );

          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Order placed successfully!")),
            );
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
