import 'package:flutter/material.dart';

class DotSlide extends StatefulWidget {
  @override
  _DotSlideState createState() => _DotSlideState();
}

class _DotSlideState extends State<DotSlide> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<String> images = [
    'https://via.placeholder.com/300/FF5733/FFFFFF?text=Image+1',
    'https://via.placeholder.com/300/33FF57/FFFFFF?text=Image+2',
    'https://via.placeholder.com/300/3357FF/FFFFFF?text=Image+3',
  ];

  @override
  void initState() {
    super.initState();
    // Listen to the PageController's page changes
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // PageView for images
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _pageController,
            itemCount: images.length,
            itemBuilder: (context, index) {
              return Image.network(
                images[index],
                fit: BoxFit.cover,
              );
            },
          ),
        ),
        // Dots indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(images.length, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              width: _currentPage == index ? 12.0 : 8.0,
              height: 8.0,
              decoration: BoxDecoration(
                color: _currentPage == index ? Colors.blue : Colors.grey,
                borderRadius: BorderRadius.circular(4.0),
              ),
            );
          }),
        ),
      ],
    );
  }
}

// void main() {
//   runApp(MaterialApp(
//     home: Scaffold(
//       appBar: AppBar(title: Text("Image Slider with Dots")),
//       body: DotSlide(),
//     ),
//   ));
// }
