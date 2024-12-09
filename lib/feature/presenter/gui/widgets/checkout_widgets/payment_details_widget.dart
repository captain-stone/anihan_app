import 'package:flutter/material.dart';

class PaymentDetailsWidget extends StatelessWidget {
  final double total;
  const PaymentDetailsWidget({super.key, required this.total});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow("Merchandise Subtotal", "₱$total"),
            _buildDetailRow("Shipping Subtotal", "₱50"),
            const Divider(),
            _buildDetailRow("Total Payment", "₱${total + 50}", isBold: true),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String amount, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style:
                  isBold ? const TextStyle(fontWeight: FontWeight.bold) : null),
          Text(amount,
              style:
                  isBold ? const TextStyle(fontWeight: FontWeight.bold) : null),
        ],
      ),
    );
  }
}
