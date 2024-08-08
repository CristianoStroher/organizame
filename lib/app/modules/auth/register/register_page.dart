import 'package:flutter/material.dart';
import 'package:organizame/app/core/Widget/organizame_elevatebutton.dart';
import 'package:organizame/app/core/Widget/organizame_logo.dart';
import 'package:organizame/app/core/Widget/organizame_textformfield.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false, // Retirar o botão de voltar
        backgroundColor: context.scaffoldBackgroundColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context); // Voltar à tela anterior
          },
          icon: ClipOval(
            child: Container(
              color: context.primaryColor.withAlpha(20),
              padding: const EdgeInsets.all(5),
              child: Icon(
                Icons.arrow_back_ios_new_outlined,
                color: context.primaryColor,
              ),
            ),
          ),
        ),
        title: Text(
          'Cadastro',
          style: context.titleMedium,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.width * .5,
              child: const FittedBox(
                fit: BoxFit.fitWidth,
                child: OrganizameLogo(),
              ),
            ),
            const SizedBox(height: 20),
            OrganizameTextformfield(label: 'Nome', obscureText: false),
            const SizedBox(height: 20),
            OrganizameTextformfield(label: 'E-mail', obscureText: false),
            const SizedBox(height: 20),
            OrganizameTextformfield(label: 'Senha', obscureText: true),
            const SizedBox(height: 20),
            OrganizameTextformfield(label: 'Confirmar Senha', obscureText: true),
            const SizedBox(height: 30),
            OrganizameElevatedButton(label: 'Cadastrar', onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
