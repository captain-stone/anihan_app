import 'package:anihan_app/feature/domain/entities/product_entity.dart';
import 'package:anihan_app/feature/presenter/gui/routers/app_routers.dart';
import 'package:anihan_app/feature/presenter/gui/widgets/product_sections.dart';
import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

@RoutePage()
class ShowProductByCategoryPage extends StatefulWidget {
  final String uid;
  final String label;
  final List<ProductEntity> productData;

  const ShowProductByCategoryPage(
      {super.key,
      required this.uid,
      required this.label,
      required this.productData});

  @override
  State<ShowProductByCategoryPage> createState() =>
      _ShowProductByCategoryPageState();
}

class _ShowProductByCategoryPageState extends State<ShowProductByCategoryPage> {
  final Logger logger = Logger();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              logger.d("SHDAD");
              // Navigator.of(context).pop();

              AutoRouter.of(context)
                  .replace(HomeNavigationRoute(uid: widget.uid));
            },
            icon: const Icon(Icons.arrow_back)),
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
