import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/order_details_bloc.dart';
import 'widgets/tracking_widget.dart';
import 'widgets/background_image_widget.dart';
import 'widgets/order_details_widget.dart';

class OrderDetailsPage extends StatelessWidget {
  const OrderDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.help_outline),
      ),
      body: Stack(
        children: [
          const BackgroundImageWidget(),
          Positioned(
            top: 20,
            left: 16,
            right: 16,
            child: const TrackingWidget(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: BlocProvider(
              create: (_) => OrderDetailsBloc(),
              child: const OrderDetailsWidget(),
            ),
          ),
        ],
      ),
    );
  }
}
