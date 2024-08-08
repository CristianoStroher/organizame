import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:organizame/app/core/Widget/organizame_elevatebutton.dart';
import 'package:organizame/app/core/Widget/organizame_logo.dart';
import 'package:organizame/app/core/Widget/organizame_textformfield.dart';


class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color((0xFFF9FAFF)),
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
              minWidth: constraints.maxWidth,
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(height: 40),
                  const OrganizameLogo(height: 180),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 20),
                    child: Form(
                        child: Column(
                      children: [
                        OrganizameTextformfield(label: 'E-mail', obscureText: false,),
                        const SizedBox(height: 20),
                        OrganizameTextformfield(label: 'Senha', obscureText: true,),
                        const SizedBox(height: 30),
                        OrganizameElevatedButton(
                            label: 'Entrar',
                            onPressed: () {},
                          ),
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            foregroundColor : Theme.of(context).colorScheme.secondary,
                          ),
                          child: const Text(
                            'Esqueceu a sua senha?',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    )),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorLight,
                        border: Border(
                          top: BorderSide(
                            width: 2,
                            color: Colors.grey.withAlpha(50),
                          ),
                        ),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 20,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: SizedBox(
                              width: double.infinity, // Define a largura como infinita para ocupar o máximo possível
                              child: SignInButton(
                                Buttons.Google,
                                text: 'Continue com o Google',
                                
                                padding: const EdgeInsets.all(5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ),
                          const SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Não tem uma conta?'),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamed('/register');
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor : Theme.of(context).colorScheme.secondary,
                                ),
                                child: const Text('Cadastre-se'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
