import 'package:flutter/material.dart';
import 'dart:math';

class OrganizameLogoMovie extends StatefulWidget {
  final String text; // Adiciona um parâmetro para a palavra a ser animada
  final Color part1Color; // Cor da primeira parte da palavra
  final Color part2Color; // Cor da segunda parte da palavra
  final int splitIndex; // Índice onde a palavra será dividida

  const OrganizameLogoMovie(
      {super.key,
      required this.text,
      required this.part1Color,
      required this.part2Color,
      this.splitIndex = 7});

  @override
  State<OrganizameLogoMovie> createState() => _OrganizameLogoMovieState();
}

class _OrganizameLogoMovieState extends State<OrganizameLogoMovie>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<int> _animation;
  late List<String> _permutations;
  String _currentText = ''; // Valor inicial
  bool _disposed = false;

  @override
  void initState() {
    super.initState();

    _permutations = _generatePermutations(widget.text); // Gera permutações
    _currentText = widget.text; // Inicializa com a palavra original

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
    // Divide a palavra em duas partes usando o índice fornecido
    String part1 = _currentText.substring(0, widget.splitIndex);
    String part2 = _currentText.substring(widget.splitIndex);

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: part1,
            style: TextStyle(
              color: widget.part1Color,
              fontSize: 30,
              fontFamily: 'Kanit',
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(
            text: part2,
            style: TextStyle(
              color: widget.part2Color,
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
