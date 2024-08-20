import 'package:flutter/material.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';
import 'dart:math';

class OrganizameLogoMovie extends StatefulWidget {
  const OrganizameLogoMovie({super.key});

  @override
  State<OrganizameLogoMovie> createState() => _OrganizameLogoMovieState();
}

class _OrganizameLogoMovieState extends State<OrganizameLogoMovie>
    with SingleTickerProviderStateMixin {
  
  late AnimationController _controller;
  late Animation<int> _animation;
  late List<String> _permutations;
  String _currentText = "OrganizAme";
  bool _disposed = false;

  @override
  void initState() {
    super.initState();

    _permutations = _generatePermutations("OrganizAme");

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _animation = IntTween(begin: 0, end: _permutations.length - 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut)
    )..addListener(() {
        if (!_disposed) {
          setState(() {
            _currentText = _permutations[_animation.value];
          });
        }
      });

    _controller.forward();

    _controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed && !_disposed) {
        await Future.delayed(const Duration(seconds: 5));
        _controller.reset();
        _controller.forward();
      }
    });
  }

  List<String> _generatePermutations(String input) {
    List<String> permutations = [];
    Random random = Random();

    for (int i = 0; i < 10; i++) {
      List<String> chars = input.split('');
      chars.shuffle(random);
      permutations.add(chars.join());
    }
    permutations.add(input);
    return permutations;
  }

  @override
  void dispose() {
    _disposed = true;
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String organizPart = _currentText.substring(0, 7);
    String amePart = _currentText.substring(7);

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: organizPart,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 30,
              fontFamily: 'Kanit',
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(
            text: amePart,
            style: TextStyle(
              color: context.scaffoldBackgroundColor,
              fontSize: 30,
              fontFamily: 'Kanit',
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
