import 'package:flutter/material.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';

class OrganizameHeart extends StatefulWidget {

  const OrganizameHeart({ super.key });

   @override
  State<OrganizameHeart> createState() => _OrganizameHeart();
 
}

class _OrganizameHeart extends State<OrganizameHeart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: Icon(
        Icons.favorite,
        color: context.secondaryColor, // Cor do coração
        size: 30,
      ),
    );
  }
}