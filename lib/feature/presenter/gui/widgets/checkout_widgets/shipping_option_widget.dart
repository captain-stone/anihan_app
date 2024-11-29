import 'package:flutter/material.dart';

class ShippingOptionWidget extends StatefulWidget {
  final String date;
  const ShippingOptionWidget({Key? key, required this.date}) : super(key: key);

  @override
  _ShippingOptionWidgetState createState() => _ShippingOptionWidgetState();
}

class _ShippingOptionWidgetState extends State<ShippingOptionWidget> {
  bool _isSelected = true;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.all(12),
      child: ListTile(
        leading: Checkbox(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          value: _isSelected,
          onChanged: (value) {
            setState(() {
              _isSelected = value ?? false;
            });
          },
        ),
        title: const Text("Standard Local by Seller"),
        subtitle: Text("Guaranteed to arrive by ${widget.date}"),
        trailing: const Text("₱50"),
      ),
    );
  }
}
