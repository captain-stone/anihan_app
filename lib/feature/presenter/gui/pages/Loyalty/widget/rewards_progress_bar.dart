import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../bloc/rewards_bloc.dart';
import '../bloc/rewards_state.dart';

class RewardsProgressBar extends StatelessWidget {
  final List<Map<String, dynamic>> categories = [
    {
      "title": "Fruits",
      "description": "Fresh fruits for redemption.",
      "points": 20,
      "image": "assets/apple.png",
    },
    {
      "title": "Vegetables",
      "description": "Organic vegetables to claim.",
      "points": 40,
      "image": "assets/apple.png",
    },
    {
      "title": "Seeds",
      "description": "High-quality seeds for planting.",
      "points": 60,
      "image": "assets/apple.png",
    },
    {
      "title": "Tools",
      "description": "Gardening tools and equipment.",
      "points": 80,
      "image": "assets/apple.png",
    },
    {
      "title": "Decor",
      "description": "Plant decor and accessories.",
      "points": 100,
      "image": "assets/apple.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RewardsBloc, RewardsState>(
      builder: (context, state) {
        if (state is RewardsLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is RewardsLoaded) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Progress Header: Rewards Points and Total
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Rewards: ${state.points}',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      'Goal: 100',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.black54,
                          ),
                    ),
                  ],
                ),
                SizedBox(height: 10),

                // Rewards Progress Bar with Milestones
                Stack(
                  children: [
                    // Progress Bar Background
                    Container(
                      height: 16,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[300],
                      ),
                    ),
                    // Gradient Progress Bar
                    Container(
                      height: 16,
                      width: (state.points / 100) *
                          MediaQuery.of(context).size.width *
                          0.9,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).colorScheme.primary,
                            Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                    // Milestone Indicators
                    Positioned.fill(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          categories.length,
                          (index) => _buildMilestoneMarker(
                              context, categories[index]["points"]),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),

                // Milestone Rewards Labels
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: categories.map((e) {
                    return Text(
                      '${e["points"]} pts',
                      style: Theme.of(context).textTheme.bodySmall,
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),

                // Carousel for Categories
                _buildCategoryCarousel(context, state.points),
              ],
            ),
          );
        } else if (state is RewardsError) {
          return Center(
            child: Text(
              state.message,
              style: TextStyle(color: Colors.red),
            ),
          );
        } else {
          return Center(child: Text('Unknown state'));
        }
      },
    );
  }

  /// Build a milestone marker (e.g., a small dot or icon)
  Widget _buildMilestoneMarker(BuildContext context, int milestone) {
    return Container(
      height: 16,
      width: 16,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 2,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.star,
          size: 12,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  /// Build the category carousel
  Widget _buildCategoryCarousel(BuildContext context, int points) {
    return CarouselSlider.builder(
      itemCount: categories.length,
      itemBuilder: (context, index, realIndex) {
        final category = categories[index];
        final isReached = points >= category["points"];

        return _buildCategoryCard(context, category, isReached);
      },
      options: CarouselOptions(
        height: 250,
        autoPlay: false,
        enlargeCenterPage: true,
        viewportFraction: 1.0, // Full-width cards
        enableInfiniteScroll: false,
      ),
    );
  }

  /// Build individual category card
  Widget _buildCategoryCard(
      BuildContext context, Map<String, dynamic> category, bool isReached) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isReached
            ? Theme.of(context).colorScheme.primary
            : Colors.grey[400],
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              category['image'],
              height: 100,
              width: 100,
              fit: BoxFit.cover,
              color: isReached ? null : Colors.grey,
              colorBlendMode: isReached ? null : BlendMode.saturation,
            ),
          ),
          SizedBox(width: 16),

          // Text Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category['title'],
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: 4),
                Text(
                  category['description'],
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                      ),
                ),
                SizedBox(height: 8),
                Text(
                  'Requires: ${category["points"]} pts',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
