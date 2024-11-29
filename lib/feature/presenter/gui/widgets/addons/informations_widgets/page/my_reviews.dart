import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ReviewsPage extends StatefulWidget {
  const ReviewsPage({Key? key}) : super(key: key);

  @override
  _ReviewsPageState createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  int _selectedIndex = 2;

  List<Map<String, dynamic>> reviews = [
    // {
    //   'name': 'John Wick',
    //   'location': 'Bagbag, Tanauan City, Batangas',
    //   'productName': 'Rambutan',
    //   'images': ['assets/fruits/rambutan.jpg', 'assets/logo.png'],
    //   'rating': 5,
    //   'quality': 'Excellent',
    //   'service': 'Superb',
    //   'personalComment': 'Loved it!',
    // },
    // {
    //   'name': 'Jane Doe',
    //   'location': 'Makati City, Metro Manila',
    //   'productName': 'Mango',
    //   'images': ['assets/fruits/manga.jpg', 'assets/logo.png'],
    //   'rating': 4,
    //   'quality': 'Great',
    //   'service': 'Good',
    //   'personalComment': 'Highly recommend the mangoes here!',
    // },
    // {
    //   'name': 'Sam Smith',
    //   'location': 'Davao City, Davao del Sur',
    //   'productName': 'Durian',
    //   'images': ['assets/fruits/durian.jpg', 'assets/logo.png'],
    //   'rating': 3,
    //   'quality': 'Average',
    //   'service': 'Okay',
    //   'personalComment': 'Not for everyone, but worth a try.',
    // },
    // {
    //   'name': 'Lisa Ray',
    //   'location': 'Cebu City, Cebu',
    //   'productName': 'Pineapple',
    //   'images': ['assets/fruits/pinya.jpg', 'assets/logo.png'],
    //   'rating': 5,
    //   'quality': 'Excellent',
    //   'service': 'Outstanding',
    //   'personalComment': 'Best pineapple I\'ve ever had!',
    // },
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    print("Selected index: $index");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: CustomAppBar(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "My Reviews",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                  ),
                ),
              )),
          // Wrap ReviewsList with Expanded to allow scrolling
          Expanded(
            child: ReviewsList(reviews: reviews),
          ),
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

class CustomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                  hintText: 'Search Reviews',
                  prefixIcon: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: Icon(Icons.search, size: 24.0),
                  ),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 40,
                    minHeight: 40,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                      color: Colors.green,
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 1.0,
                    ),
                  ),
                ),
                onChanged: (value) {
                  // Placeholder for future search function
                },
              ),
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.chat_rounded), // New chats icon
            onPressed: () {
              // Placeholder for future chats function
            },
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      elevation: 0,
    );
  }
}

class ReviewsList extends StatelessWidget {
  final List<Map<String, dynamic>> reviews;

  const ReviewsList({Key? key, required this.reviews}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (reviews.isNotEmpty) {
      return ListView.builder(
        padding: const EdgeInsets.all(12.0),
        itemCount: reviews.length,
        itemBuilder: (context, index) {
          final review = reviews[index];
          return ReviewItem(
            name: review['name'],
            location: review['location'],
            productName: review['productName'],
            images: List<String>.from(review['images']),
            rating: review['rating'],
            quality: review['quality'],
            service: review['service'],
            personalComment: review['personalComment'],
          );
        },
      );
    } else {
      return const Center(child: Text("No Reviews yet."));
    }
  }
}

class ReviewItem extends StatelessWidget {
  final String name;
  final String location;
  final String productName;
  final List<String> images;
  final int rating;
  final String quality;
  final String service;
  final String personalComment;

  const ReviewItem({
    Key? key,
    required this.name,
    required this.location,
    required this.productName,
    required this.images,
    required this.rating,
    required this.quality,
    required this.service,
    required this.personalComment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row for name, location, and view button
            Row(
              children: [
                const CircleAvatar(
                  radius: 25.0,
                  backgroundImage:
                      AssetImage('assets/avatar.jpg'), // Placeholder avatar
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: Theme.of(context).textTheme.bodyLarge),
                      Text(location,
                          style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: const Text('View'),
                ),
              ],
            ),
            const SizedBox(height: 16.0),

            // Product name and rating
            Text(
              productName,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Row(
              children: [
                Row(
                  children: List.generate(
                    5,
                    (index) => Icon(
                      Icons.star,
                      size: 18.0,
                      color: index < rating
                          ? Colors.yellow.shade700
                          : Colors.grey.shade300,
                    ),
                  ),
                ),
                const SizedBox(width: 5.0),
                Text('($rating/5)',
                    style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
            const SizedBox(height: 16.0),

            // Quality and Service aligned in columns
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quality: ',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(quality,
                        style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Service: ',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(service,
                        style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16.0),

            // Personal Comments
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Personal Comments:',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 5.0),
                Text(personalComment,
                    style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
            const SizedBox(height: 16.0),

            // Image carousel moved to the bottom
            Container(
              width: double.infinity,
              height: 100.0,
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 100.0,
                  enableInfiniteScroll: false,
                  viewportFraction: 1.0,
                ),
                items: images.map((image) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.asset(
                      image,
                      fit: BoxFit.cover,
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
