import 'package:flutter/material.dart';

class TrackingWidget extends StatefulWidget {
  const TrackingWidget({super.key});

  @override
  State<TrackingWidget> createState() => _TrackingWidgetState();
}

class _TrackingWidgetState extends State<TrackingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  int _currentStatus =
      2; // Example: 0 = Order Placed, 1 = Shipped, 2 = Out for Delivery, 3 = Delivered

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward(); // Start animation when the widget is built
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(30.0),
            bottomRight: Radius.circular(30.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.check_circle,
                    color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 10),
                Text(
                  'Order Placed',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Expected delivery date:\nJanuary 8th - Between 9:00am and 12:00pm',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.black87,
                  ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Icon(Icons.payment,
                    color: Theme.of(context).colorScheme.secondary),
                const SizedBox(width: 10),
                Text(
                  'Cash on Delivery\nTotal: P1200',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(),
            _buildDeliveryStatusIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryStatusIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStatusStep(
          icon: Icons.circle,
          label: 'Order Placed',
          isActive: _currentStatus >= 0,
        ),
        _buildStatusLine(isActive: _currentStatus >= 1),
        _buildStatusStep(
          icon: Icons.local_shipping,
          label: 'Shipped',
          isActive: _currentStatus >= 1,
        ),
        _buildStatusLine(isActive: _currentStatus >= 2),
        _buildStatusStep(
          icon: Icons.delivery_dining,
          label: 'Out for Delivery',
          isActive: _currentStatus >= 2,
        ),
        _buildStatusLine(isActive: _currentStatus >= 3),
        _buildStatusStep(
          icon: Icons.home,
          label: 'Delivered',
          isActive: _currentStatus >= 3,
        ),
      ],
    );
  }

  Widget _buildStatusStep({
    required IconData icon,
    required String label,
    required bool isActive,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: isActive ? Theme.of(context).colorScheme.primary : Colors.grey,
          size: 28.0,
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isActive
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
        ),
      ],
    );
  }

  Widget _buildStatusLine({required bool isActive}) {
    return Expanded(
      child: Container(
        height: 4.0,
        color:
            isActive ? Theme.of(context).colorScheme.primary : Colors.grey[300],
      ),
    );
  }
}
