import 'package:flutter/material.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';

class Customer extends StatelessWidget {
  const Customer({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('RELAÇÃO DE CLIENTES', 
        style: context.titleDefaut),
      ],
    ));
  }
}
