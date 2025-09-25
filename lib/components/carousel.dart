// lib/components/carousel.dart
import 'package:flutter/material.dart';
// --- THIS IS THE FIX (Part 1) ---
// We're giving the carousel_slider library the nickname "cs"
import 'package:carousel_slider/carousel_slider.dart' as cs;
import 'package:smart_transit/components/button.dart'; // We'll use our custom button

class AppCarousel extends StatefulWidget {
  final List<Widget> items;
  final double height;
  final double viewportFraction;

  const AppCarousel({
    super.key,
    required this.items,
    this.height = 200,
    this.viewportFraction = 0.85,
  });

  @override
  State<AppCarousel> createState() => _AppCarouselState();
}

class _AppCarouselState extends State<AppCarousel> {
  // --- THIS IS THE FIX (Part 2) ---
  // We now specify that we want the CarouselController from our "cs" nickname.
  final cs.CarouselController _controller = cs.CarouselController();
  bool _canScrollPrev = false;
  bool _canScrollNext = true;

  @override
  void initState() {
    super.initState();
    if (widget.items.length <= 1) {
      _canScrollNext = false;
    }
  }

  void _onPageChanged(int index, cs.CarouselPageChangedReason reason) {
    setState(() {
      _canScrollPrev = index > 0;
      _canScrollNext = index < widget.items.length - 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        cs.CarouselSlider(
          // Also prefixed here
          items: widget.items,
          carouselController: _controller,
          options: cs.CarouselOptions(
            // And here
            height: widget.height,
            viewportFraction: widget.viewportFraction,
            enableInfiniteScroll: false,
            enlargeCenterPage: true,
            enlargeFactor: 0.2,
            onPageChanged: _onPageChanged,
          ),
        ),
        Positioned(
          left: 0,
          child: AppButton(
            onPressed: _canScrollPrev ? () => _controller.previousPage() : null,
            icon: Icons.arrow_back_ios_new,
            size: ButtonSize.icon,
            variant: ButtonVariant.outline,
          ),
        ),
        Positioned(
          right: 0,
          child: AppButton(
            onPressed: _canScrollNext ? () => _controller.nextPage() : null,
            icon: Icons.arrow_forward_ios,
            size: ButtonSize.icon,
            variant: ButtonVariant.outline,
          ),
        ),
      ],
    );
  }
}
