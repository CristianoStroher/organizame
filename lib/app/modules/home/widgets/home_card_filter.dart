import 'package:flutter/material.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';

class HomeCardFilter extends StatelessWidget {
  const HomeCardFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 100,
        maxWidth: 150,
      ),
      decoration: BoxDecoration(
        color: context.primaryColorLight,
        borderRadius: BorderRadius.circular(3),
      ),
      margin: const EdgeInsets.only(right: 15),
      padding: const EdgeInsets.all(10),
    );
  }
}
