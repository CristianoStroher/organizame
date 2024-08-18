import 'package:flutter/material.dart';
import 'package:organizame/app/core/auth/auth_provider.dart';
import 'package:organizame/app/modules/home/widgets/home_drawer.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {

  const HomePage({ super.key });

   @override
   Widget build(BuildContext context) {
       return Scaffold(
        appBar: AppBar( title: const Text('Home')),
        drawer: HomeDrawer(),
           body: Center(
            child: TextButton(
              onPressed: () {
                context.read<AuthProvider>().logout();
              },
              child: const Text('Logout'),
            ),
           ),
       );
  }
}