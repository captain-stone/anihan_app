import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/rewards_bloc.dart';
import 'widget/explore_carousel.dart';
import 'widget/rewards_progress_bar.dart';
import 'widget/category_tab_menu.dart';
import 'bloc/rewards_event.dart';

class LoyaltyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Loyalty',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white, // Override color for AppBar
              ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header for Explore Section
              Text(
                'Explore',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: 8),
              // Explore Carousel Section
              ExploreCarousel(),
              SizedBox(height: 24),

              // Header for Rewards Progress Bar
              Text(
                'Rewards',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: 8),
              // Rewards Progress Bar Section
              RewardsProgressBar(),
              SizedBox(height: 24),

              // Header for Category Tab Menu
              Text(
                'Redeemable Categories',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: 8),
              // Category Tab Menu Section
              CategoryTabMenu(
                categories: [
                  {
                    "name": "Fruits",
                    "icon": Icons.local_offer,
                    "subcategories": [
                      {
                        "title": "Citrus",
                        "color": Colors.orange,
                        "items": ["Orange", "Lemon", "Lime"]
                      },
                      {
                        "title": "Berries",
                        "color": Colors.red,
                        "items": ["Strawberry", "Blueberry", "Raspberry"]
                      },
                    ]
                  },
                  {
                    "name": "Vegetables",
                    "icon": Icons.eco,
                    "subcategories": [
                      {
                        "title": "Leafy Greens",
                        "color": Colors.green,
                        "items": ["Spinach", "Lettuce", "Kale"]
                      },
                      {
                        "title": "Roots",
                        "color": Colors.brown,
                        "items": ["Carrot", "Beetroot", "Radish"]
                      },
                    ]
                  },
                  {
                    "name": "Seeds",
                    "icon": Icons.grass,
                    "subcategories": [
                      {
                        "title": "Flower Seeds",
                        "color": Colors.yellow,
                        "items": ["Marigold", "Rose", "Sunflower"]
                      },
                      {
                        "title": "Vegetable Seeds",
                        "color": Colors.teal,
                        "items": ["Tomato", "Cucumber", "Pepper"]
                      },
                    ]
                  },
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
