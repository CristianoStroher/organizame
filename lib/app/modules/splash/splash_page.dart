import 'package:flutter/material.dart';

import 'package:organizame/app/core/widget/organizame_logo_branco.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.primaryColor,
      body: const Center(
        child: OrganizameLogoBranco(),
      ),
    );
  }
}
