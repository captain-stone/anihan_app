import 'package:anihan_app/feature/presenter/gui/widgets/location_item.dart';
import 'package:flutter/material.dart';

class TrendingLocationsSection extends StatelessWidget {
  final List<String> locations = ['Tanauan', 'Sambat', 'Malvar', 'Sto. Tomas'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Trending Locations',
            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  fontSize: 20.0,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ),
        Container(
          height: 160.0, // Adjusted height to fit placeholder content
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: locations.length,
            itemBuilder: (context, index) {
              return LocationItem(location: locations[index]);
            },
          ),
        ),
      ],
    );
  }
}
