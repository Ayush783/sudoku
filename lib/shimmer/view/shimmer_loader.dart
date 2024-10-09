import 'package:flutter/material.dart';

class ShimmerLoader extends StatefulWidget {
  const ShimmerLoader({super.key});

  @override
  State<ShimmerLoader> createState() => _ShimmerLoaderState();
}

class _ShimmerLoaderState extends State<ShimmerLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
      lowerBound: 0.25,
      upperBound: 1.0,
    );
    animate();
    super.initState();
  }

  void animate() {
    animationController.forward();
    animationController.addListener(
      () => switch (animationController.value) {
        1.0 => animationController.reverse(),
        0.25 => animationController.forward(),
        _ => null,
      },
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBox(92, 32),
              _buildBox(52, 32),
            ],
          ),
          const SizedBox(height: 16),
          _buildBox(size.width, size.height / 2.5),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(5, (index) => _buildBox(50, 50)),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(4, (index) => _buildBox(50, 50)),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(4, (index) => _buildBox(64, 64)),
          ),
          const Spacer(),
          _buildBox(size.width, 60),
        ],
      ),
    );
  }

  AnimatedBuilder _buildBox(double width, double height) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) =>
          FadeTransition(opacity: animationController, child: child),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xfff1f1f1),
          borderRadius: BorderRadius.circular(8),
        ),
        height: height,
        width: width,
      ),
    );
  }
}
