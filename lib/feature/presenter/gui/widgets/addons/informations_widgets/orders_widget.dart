import 'package:flutter/material.dart';

class MyOrdersWidget extends StatelessWidget {
  const MyOrdersWidget({Key? key}) : super(key: key);

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
            _buildOrdersHeader(),
            const SizedBox(height: 16),
            _buildOrderStatusRow(),
          ],
        ),
      ),
    );
  }

  Row _buildOrdersHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'My Orders',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: const Text(
            'History',
            style: TextStyle(
              fontSize: 14,
              color: Colors.green,
            ),
          ),
        ),
      ],
    );
  }

  Row _buildOrderStatusRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildOrderStatusItem('To Pay', Icons.payment, 0),
        _buildOrderStatusItem('To Ship', Icons.local_shipping, 0),
        _buildOrderStatusItem('Ongoing', Icons.sync, 0),
        _buildOrderStatusItem('Done', Icons.check_circle_outline, 0),
      ],
    );
  }

  Widget _buildOrderStatusItem(String label, IconData icon, int count) {
    return Expanded(
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(8.0),
        splashColor: Colors.green.withOpacity(0.2),
        child: AnimatedScale(
          scale: 1.0,
          duration: const Duration(milliseconds: 150),
          child: Ink(
            child: Column(
              children: [
                Stack(
                  children: [
                    Icon(icon, size: 32, color: Colors.black87),
                    if (count > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            '$count',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
