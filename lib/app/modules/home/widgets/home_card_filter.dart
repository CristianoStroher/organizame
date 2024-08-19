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
        color: context.primaryColor,
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: Colors.grey.withOpacity(.8), width: 1),
      ),
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '10 TAREFAS',
            style: TextStyle(
              color: context.scaffoldBackgroundColor,
              fontSize: 10),
          ),
          Text(
            'HOJE',
            style: TextStyle(
                color: context.scaffoldBackgroundColor,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          LinearProgressIndicator(
            value: .5,
            backgroundColor: context.primaryColorLight.withOpacity(.8),
            valueColor: const AlwaysStoppedAnimation(Colors.white),
          ),
        ],
      ),
    );
  }
}
