import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final void Function()? addProducts;

  const SectionTitle({required this.title, this.addProducts, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Visibility(
              visible: addProducts == null ? false : true,
              child: TextButton(
                  onPressed: addProducts, child: const Text("Add Products")))
        ],
      ),
    );
  }
}
