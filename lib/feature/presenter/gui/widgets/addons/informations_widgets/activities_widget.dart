import 'package:anihan_app/feature/presenter/gui/widgets/addons/informations_widgets/page/my_reviews.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../routers/app_routers.dart';

class ActivitiesWidget extends StatelessWidget {
  final String uid;

  const ActivitiesWidget({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Activities',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            _buildActivityRow([
              _buildActivityItem(
                  'Wishlist', Icons.favorite, Colors.red, context),
              _buildActivityItem(
                  'Buy Again', Icons.shopping_bag, Colors.green, context),
            ]),
            _buildActivityRow([
              _buildActivityItem(
                  'My Reviews', Icons.rate_review, Colors.amber, context),
              _buildActivityItem(
                  'Viewed Products', Icons.history, Colors.blue, context),
            ]),
          ],
        ),
      ),
    );
  }

  Row _buildActivityRow(List<Widget> items) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: items,
    );
  }

  Widget _buildActivityItem(
      String label, IconData icon, Color iconColor, BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: Colors.grey[300]!,
            width: 1.0,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(8.0),
            onTap: () {
              if (label == 'Wishlist') {
                AutoRouter.of(context).push(MyLikeRoute(uid: uid));
              }
              if (label == "My Reviews") {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ReviewsPage()));
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 28, color: iconColor),
                  const SizedBox(height: 8),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
