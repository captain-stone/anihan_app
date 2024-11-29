import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/order_details_bloc.dart';

class OrderDetailsWidget extends StatelessWidget {
  const OrderDetailsWidget({super.key});

  final List<Map<String, dynamic>> orderedItems = const [
    {"name": "Banana - 65 per kilo", "quantity": 10, "price": "P650"},
    {"name": "Apple - 50 per kilo", "quantity": 5, "price": "P250"},
    {"name": "Mango - 75 per kilo", "quantity": 3, "price": "P225"},
    {"name": "Orange - 40 per kilo", "quantity": 8, "price": "P320"},
    {"name": "Grapes - 90 per kilo", "quantity": 2, "price": "P180"},
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderDetailsBloc, OrderDetailsState>(
      builder: (context, state) {
        final bool isExpanded = state.isExpanded;
        final double maxHeight = MediaQuery.of(context).size.height * 0.6;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          height: isExpanded ? maxHeight : 200,
          padding: const EdgeInsets.all(20.0),
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  if (isExpanded) {
                    context
                        .read<OrderDetailsBloc>()
                        .add(OrderDetailsEvent.collapse);
                  } else {
                    context
                        .read<OrderDetailsBloc>()
                        .add(OrderDetailsEvent.expand);
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Order Details',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_up,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
              ),
              const Divider(),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: const Icon(Icons.person, color: Colors.white),
                ),
                title: Text('Cess Terfield',
                    style: Theme.of(context).textTheme.bodyLarge),
                subtitle: Text(
                  'Banjo West, Tanauan City, Batangas\nCall me when the package arrived',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                trailing:
                    Text('P1200', style: Theme.of(context).textTheme.bodyLarge),
              ),
              const Divider(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: orderedItems.map((item) {
                      return _buildOrderItem(context, item["name"],
                          item["quantity"], item["price"]);
                    }).toList(),
                  ),
                ),
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total:', style: Theme.of(context).textTheme.titleLarge),
                  Text('P1200', style: Theme.of(context).textTheme.titleLarge),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOrderItem(
      BuildContext context, String name, int quantity, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$name x$quantity',
              style: Theme.of(context).textTheme.bodyMedium),
          Text(price, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}
