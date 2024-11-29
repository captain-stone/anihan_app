import 'package:anihan_app/feature/presenter/gui/widgets/addons/informations_widgets/page/list_product.dart';
import 'package:flutter/material.dart';

import '../../../../../../../common/api_result.dart';
import '../../../../../../domain/entities/product_entity.dart';

class WishlistSection extends StatelessWidget {
  final String label;
  final String uid;
  final List<ProductEntity> productEntityList;
  final Size size;

  WishlistSection(
      {Key? key,
      this.label = "Wishlist",
      required this.uid,
      required this.productEntityList,
      required this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            label,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        _buildProductGrid(context, productEntityList),
      ],
    );
  }

  Widget _buildProductGrid(BuildContext context, List<ProductEntity> products) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 0.75,
        ),
        itemBuilder: (context, index) {
          return ListProduct(
            parentContext: context,
            uid: uid,
            product: products[index],
            dist: ProductDist.suggestions,
          );
        },
      ),
    );
  }
}
