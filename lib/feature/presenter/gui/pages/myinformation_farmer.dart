// ignore_for_file: library_private_types_in_public_api

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class MyInformationFarmerPage extends StatefulWidget {
  const MyInformationFarmerPage({super.key});

  @override
  _MyInformationFarmerPageState createState() =>
      _MyInformationFarmerPageState();
}

class _MyInformationFarmerPageState extends State<MyInformationFarmerPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // Implement loading more items when scrolled to the bottom
    }
  }

  int _selectedIndex = 2; // Default selected index is "Home"

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        controller: _scrollController,
        children: const [
          HeaderWidget(),
          MyOrdersWidget(),
          ActivitiesWidget(),
          SectionTitle(title: 'You May Like'),
          YouMayLikeWidget(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green.shade700,
        unselectedItemColor: Colors.black54,
        backgroundColor: Colors.white,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        elevation: 8.0,
        onTap: _onItemTapped,
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }
}

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderRow(context),
          const SizedBox(height: 20.0),
          _buildProfileSection(context),
        ],
      ),
    );
  }

  Row _buildHeaderRow(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        const SizedBox(width: 10.0),
        Text(
          'My Information',
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
        ),
        const Spacer(),
        _buildHeaderIcons(),
      ],
    );
  }

  Row _buildHeaderIcons() {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.refresh, color: Colors.white),
          onPressed: () {},
        ),
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_cart, color: Colors.white),
              onPressed: () {},
            ),
            const Positioned(
              right: 4,
              top: 4,
              child: CircleAvatar(
                radius: 10.0,
                backgroundColor: Colors.red,
                child: Text(
                  '2',
                  style: TextStyle(color: Colors.white, fontSize: 12.0),
                ),
              ),
            ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.settings, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }

  Row _buildProfileSection(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 32.0,
          backgroundColor: Colors.grey[300],
          child: const Icon(Icons.person, color: Colors.white, size: 36.0),
        ),
        const SizedBox(width: 12.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileNameWithIcon(context),
              _buildMemberSinceText(context),
              _buildUserBadge(),
            ],
          ),
        ),
        const SizedBox(width: 12.0),
        _buildSellButton(),
      ],
    );
  }

  Row _buildProfileNameWithIcon(BuildContext context) {
    return Row(
      children: [
        Text(
          'Jack King',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
        IconButton(
          icon: const Icon(Icons.card_giftcard, color: Colors.white),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.store, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }

  Text _buildMemberSinceText(BuildContext context) {
    return Text(
      'Member since 04/17/24',
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.white,
          ),
    );
  }

  Container _buildUserBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.yellow[800],
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: const Text(
        'Farmer',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );
  }

  ElevatedButton _buildSellButton() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
          side: const BorderSide(color: Colors.white),
        ),
        elevation: 0, // Flat look like the reference
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.storefront,
              color: Colors.black), // Replacing with a storefront icon
          SizedBox(width: 8),
          Text(
            'Sell Your Own',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 8),
          Icon(Icons.arrow_forward, color: Colors.black),
        ],
      ),
    );
  }
}

class MyOrdersWidget extends StatelessWidget {
  const MyOrdersWidget({super.key});

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
        _buildOrderStatusItem('To Pay', Icons.payment, 2),
        _buildOrderStatusItem('To Ship', Icons.local_shipping, 0),
        _buildOrderStatusItem('Ongoing', Icons.sync, 4),
        _buildOrderStatusItem('Done', Icons.check_circle_outline, 73),
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

class ActivitiesWidget extends StatelessWidget {
  const ActivitiesWidget({super.key});

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
              _buildActivityItem('My Likes', Icons.favorite, Colors.red),
              _buildActivityItem('Buy Again', Icons.shopping_bag, Colors.green),
            ]),
            _buildActivityRow([
              _buildActivityItem('My Reviews', Icons.rate_review, Colors.amber),
              _buildActivityItem('Viewed Products', Icons.history, Colors.blue),
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

  Widget _buildActivityItem(String label, IconData icon, Color iconColor) {
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
            onTap: () {},
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

class Product {
  final String imageUrl;
  final String name;
  final double price;

  Product({required this.imageUrl, required this.name, required this.price});
}

class YouMayLikeWidget extends StatefulWidget {
  const YouMayLikeWidget({super.key});

  @override
  _YouMayLikeWidgetState createState() => _YouMayLikeWidgetState();
}

class _YouMayLikeWidgetState extends State<YouMayLikeWidget> {
  late Future<List<Product>> _recommendedProductsFuture;

  @override
  void initState() {
    super.initState();
    _recommendedProductsFuture = _fetchRecommendedProducts();
  }

  Future<List<Product>> _fetchRecommendedProducts() async {
    await Future.delayed(const Duration(seconds: 2));

    return List.generate(
      10,
      (index) => Product(
        imageUrl: 'https://via.placeholder.com/150',
        name: 'Product ${index + 1}',
        price: (index + 1) * 10.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: _recommendedProductsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Failed to load products. Please try again.'),
          );
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return _buildProductGrid(snapshot.data!);
        } else {
          return const Center(
            child: Text('No recommended products available.'),
          );
        }
      },
    );
  }

  Widget _buildProductGrid(List<Product> products) {
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
          return _buildProductCard(products[index]);
        },
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Image.network(
              product.imageUrl,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              product.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
