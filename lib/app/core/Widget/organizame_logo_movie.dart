import 'package:flutter/material.dart';

class OrganizameLogoMovie extends StatefulWidget {
  const OrganizameLogoMovie({super.key});

  @override
  _OrganizameLogoMovieState createState() => _OrganizameLogoMovieState();
}

class _OrganizameLogoMovieState extends State<OrganizameLogoMovie>
    with SingleTickerProviderStateMixin {
      
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: 'Organiz',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 30,
                fontFamily: 'Kanit',
                fontWeight: FontWeight.w600,
              ),
            ),
            TextSpan(
              text: 'Ame',
              style: TextStyle(
                color: Theme.of(context).scaffoldBackgroundColor,
                fontSize: 30,
                fontFamily: 'Kanit',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
