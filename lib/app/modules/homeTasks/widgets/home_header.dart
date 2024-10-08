import 'package:flutter/material.dart';
import 'package:organizame/app/core/auth/auth_provider.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';
import 'package:provider/provider.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Selector(
            selector: (_, AuthProvider authProvider) => authProvider.user,
            builder: (context, value, child) => Text(
              '${value?.displayName?.split(' ').first ?? 'Visitante'}, seja bem-vindo!',
              style: context.titleMedium,
            ),
          ),
          const SizedBox(height: 5),
          Text('Confira suas tarefas agendadas.',
              style: TextStyle(fontSize: 16, color: context.primaryColor)),
        ],
      ),
    );
  }
}
