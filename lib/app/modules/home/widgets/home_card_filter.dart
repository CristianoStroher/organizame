import 'package:flutter/material.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';

class HomeCardFilter extends StatelessWidget {

  final String label;
  final Color color;
  final Color borderColor;
  final Color textColor;
  final Color linearProgress;
  final Color value;
  
  const HomeCardFilter({
    super.key,
    required this.label,
    required this.color,
    required this.borderColor,
    required this.textColor,
    required this.linearProgress,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 100,
        maxWidth: 150,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor, width: 1),
      ),
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '10 TAREFAS',
            style: TextStyle(
              color: textColor,
              fontSize: 10),
          ),
          Text(
            label,
            style: TextStyle(
                color: textColor,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          LinearProgressIndicator(
            value: .5,
            backgroundColor: linearProgress.withOpacity(.8),
            valueColor: AlwaysStoppedAnimation(value),
          ),
        ],
      ),
    );
  }
}
