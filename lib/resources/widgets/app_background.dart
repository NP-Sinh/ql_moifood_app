import 'dart:math';
import 'package:flutter/material.dart';

class _FloatingIcon {
  final IconData icon;
  final Alignment startPos;
  final double size;
  final double opacity;
  final Duration duration; 

  _FloatingIcon({
    required this.icon,
    required this.startPos,
    required this.size,
    required this.opacity,
    required this.duration,
  });
}

class AppBackground extends StatefulWidget {
  final Widget child;
  final List<Color>? gradientColors;
  final String? imagePath;

  const AppBackground({
    super.key,
    required this.child,
    this.gradientColors,
    this.imagePath,
  });

  @override
  State<AppBackground> createState() => _AppBackgroundState();
}

class _AppBackgroundState extends State<AppBackground>
    with TickerProviderStateMixin {
  late AnimationController _gradientController;
  late Animation<Alignment> _topAlignmentAnimation;
  late Animation<Alignment> _bottomAlignmentAnimation;

  final List<_FloatingIcon> _icons = [];
  late AnimationController _iconController;

  final List<Color> _defaultMoiFoodColors = [
    Colors.orange.shade900.withOpacity(0.8),
    const Color(0xFF222222),
    const Color(0xFF111111),
  ];

  @override
  void initState() {
    super.initState();

    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);

    _topAlignmentAnimation = Tween<Alignment>(
      begin: Alignment.topLeft,
      end: Alignment.topRight,
    ).animate(_gradientController);

    _bottomAlignmentAnimation = Tween<Alignment>(
      begin: Alignment.bottomLeft,
      end: Alignment.bottomRight,
    ).animate(_gradientController);

    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();

    _icons.addAll(_generateIcons(20));
  }

  List<_FloatingIcon> _generateIcons(int count) {
    final Random random = Random();

    final List<IconData> iconList = [
      Icons.store_mall_directory_outlined, 
      Icons.person_outline, 
      Icons.fastfood_outlined, 
      Icons.delivery_dining_outlined, 
      Icons.ramen_dining_outlined,
      Icons.local_pizza_outlined,
      Icons.lunch_dining_outlined, 
      Icons.cake_outlined, 
      Icons.local_bar_outlined, 
      Icons.emoji_food_beverage_outlined, 
      Icons.icecream_outlined, 
      Icons.restaurant_menu_outlined, 
      Icons.kebab_dining_outlined, 
      Icons.tapas_outlined, 
      Icons.dinner_dining_outlined, 
    ];

    return List.generate(count, (index) {
      return _FloatingIcon(
        icon: iconList[random.nextInt(iconList.length)],
        startPos: Alignment(
          random.nextDouble() * 2 - 1, 
          1.5, 
        ),
        size: random.nextDouble() * 30 + 15, 
        opacity: random.nextDouble() * 0.15 + 0.05, 
        duration: Duration(seconds: random.nextInt(10) + 10), 
      );
    });
  }

  @override
  void dispose() {
    _gradientController.dispose();
    _iconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: _buildBackground(),
        ),

        Positioned.fill(
          child: _buildFloatingIcons(context),
        ),

        Positioned.fill(child: widget.child),
      ],
    );
  }

  Widget _buildBackground() {
    if (widget.imagePath != null) {
      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(widget.imagePath!),
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    if (widget.gradientColors != null) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: widget.gradientColors!,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      );
    }

    return AnimatedBuilder(
      animation: _gradientController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _defaultMoiFoodColors,
              begin: _topAlignmentAnimation.value,
              end: _bottomAlignmentAnimation.value,
            ),
          ),
        );
      },
    );
  }

  Widget _buildFloatingIcons(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return AnimatedBuilder(
      animation: _iconController,
      builder: (context, child) {
        return Stack(
          children: _icons.map((icon) {
            final double progress = (_iconController.value + (icon.size / 45)) % 1.0;
            final double currentY = (icon.startPos.y - (progress * 3.0));
            
            final double pixelX = (icon.startPos.x + 1) / 2 * screenSize.width;
            final double pixelY = (currentY + 1) / 2 * screenSize.height;

            return Positioned(
              left: pixelX,
              top: pixelY,
              child: Opacity(
                opacity: icon.opacity * (1.0 - progress),
                child: Icon(
                  icon.icon,
                  size: icon.size,
                  color: Colors.white,
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}