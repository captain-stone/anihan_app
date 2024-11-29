import 'package:flutter/material.dart';

class PaymentMethodWidget extends StatelessWidget {
  const PaymentMethodWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.all(12),
      child: ListTile(
        leading:
            Icon(Icons.money, color: Theme.of(context).colorScheme.primary),
        title: const Text("Cash on Delivery"),
        trailing: Icon(Icons.check_circle,
            color: Theme.of(context).colorScheme.primary),
      ),
    );
  }
}
