import 'package:flutter/material.dart';
import 'package:organizame/app/core/auth/auth_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {

  const HomePage({ super.key });

   @override
   Widget build(BuildContext context) {
       return Scaffold(
           body: Center(
            child: TextButton(
              onPressed: () {
                context.read<AuthProvider>().logout();
              },
              child: const Text('Ir para a tela de login'),
            ),
           ),
       );
  }
}