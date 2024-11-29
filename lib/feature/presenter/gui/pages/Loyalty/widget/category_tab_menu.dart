import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CategoryTabMenu extends StatefulWidget {
  final List<Map<String, dynamic>> categories;

  CategoryTabMenu({Key? key, required this.categories}) : super(key: key);

  @override
  _CategoryTabMenuState createState() => _CategoryTabMenuState();
}

class _CategoryTabMenuState extends State<CategoryTabMenu> {
  int selectedPrimaryIndex = 0; // Currently selected primary category
  int expandedSecondaryIndex =
      -1; // Currently expanded secondary tab (-1 means none)

  @override
  Widget build(BuildContext context) {
    final primaryCategory = widget.categories[selectedPrimaryIndex];
    final secondaryTabs =
        primaryCategory['subcategories'] as List<Map<String, dynamic>>;

    return Column(
      children: [
        // Primary Tab Menu
        _buildPrimaryTabMenu(),

        SizedBox(height: 16),

        // Secondary Tab Menu
        ...List.generate(secondaryTabs.length, (index) {
          final secondaryTab = secondaryTabs[index];
          final isExpanded = index == expandedSecondaryIndex;

          return GestureDetector(
            onTap: () {
              setState(() {
                expandedSecondaryIndex =
                    isExpanded ? -1 : index; // Toggle expansion
              });
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height:
                  isExpanded ? MediaQuery.of(context).size.height * 0.6 : 60,
              margin: EdgeInsets.only(bottom: isExpanded ? 0 : 8),
              decoration: BoxDecoration(
                color: secondaryTab['color'],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(isExpanded ? 0 : 16),
                  bottomRight: Radius.circular(isExpanded ? 0 : 16),
                ),
                gradient: isExpanded
                    ? LinearGradient(
                        colors: [
                          secondaryTab['color'].withOpacity(0.8),
                          secondaryTab['color'],
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      )
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: isExpanded
                  ? _buildExpandedSecondaryContent(secondaryTab)
                  : _buildCollapsedSecondaryTab(secondaryTab['title']),
            ),
          );
        }),
      ],
    );
  }

  /// Builds the primary tab menu (horizontal scrollable)
  Widget _buildPrimaryTabMenu() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(widget.categories.length, (index) {
          final category = widget.categories[index];
          final isSelected = index == selectedPrimaryIndex;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedPrimaryIndex = index;
                expandedSecondaryIndex =
                    -1; // Reset secondary tab when changing primary category
              });
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 8),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey[300],
                borderRadius: BorderRadius.circular(24),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: Row(
                children: [
                  if (category['icon'] != null)
                    Icon(
                      category['icon'],
                      color: isSelected ? Colors.white : Colors.black54,
                    ),
                  if (category['icon'] != null) SizedBox(width: 8),
                  Text(
                    category['name'],
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  /// Builds the collapsed secondary tab
  Widget _buildCollapsedSecondaryTab(String title) {
    return Center(
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Builds the expanded content for a secondary tab
  Widget _buildExpandedSecondaryContent(Map<String, dynamic> secondaryTab) {
    final items = secondaryTab['items'] as List<String>;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Secondary Tab Header
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            secondaryTab['title'],
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // Grid Content
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              physics: BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 3 items per row
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return _buildGridItem(item);
              },
            ),
          ),
        ),
      ],
    );
  }

  /// Builds individual grid items in the expanded secondary tab
  Widget _buildGridItem(String item) {
    return Column(
      children: [
        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[200],
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              Icons.eco,
              color: Colors.green,
              size: 28,
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          item,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
