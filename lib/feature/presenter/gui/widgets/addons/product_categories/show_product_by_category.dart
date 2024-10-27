import 'package:anihan_app/feature/domain/entities/product_entity.dart';
import 'package:anihan_app/feature/presenter/gui/widgets/product_sections.dart';
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ShowProductByCategoryPage extends StatefulWidget {
  final String label;
  final List<ProductEntity> productData;

  const ShowProductByCategoryPage(
      {super.key, required this.label, required this.productData});

  @override
  State<ShowProductByCategoryPage> createState() =>
      _ShowProductByCategoryPageState();
}

class _ShowProductByCategoryPageState extends State<ShowProductByCategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.label),
      ),
      body: widget.productData.isNotEmpty
          ? SingleChildScrollView(
              child: ProductsSection(state: widget.productData))
          : Center(
              child: Text("No ${widget.label} available on the market"),
            ),
    );
  }
}
