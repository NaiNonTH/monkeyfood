import 'package:flutter/material.dart';

class Carousel extends StatefulWidget {
  const Carousel({super.key});

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: CarouselView(
        itemExtent: double.infinity,
        scrollDirection: Axis.horizontal,
        itemSnapping: true,
        children: List.generate(
          4,
          (int index) => Card(
            child: Image.network(
              'http://picsum.photos/800/450?random=$index',
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
        ),
      ),
    );
  }
}
