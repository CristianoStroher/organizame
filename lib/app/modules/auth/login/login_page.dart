import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:logger/logger.dart';
import 'package:organizame/app/core/Widget/organizame_elevatebutton.dart';
import 'package:organizame/app/core/Widget/organizame_logo.dart';
import 'package:organizame/app/core/Widget/organizame_textformfield.dart';
import 'package:organizame/app/core/notifier/defaut_listener_notifier.dart';
import 'package:organizame/app/core/ui/messages.dart';
import 'package:organizame/app/modules/auth/login/login_controller.dart';
import 'package:provider/provider.dart';
import 'package:validatorless/validatorless.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailEC = TextEditingController();
  final _passwordEC = TextEditingController();
  final _emailFN = FocusNode();

  @override
  void initState() {
    super.initState();
    DefautListenerNotifier(
      changeNotifier: context.read<LoginController>(),
    ).listener(
      context: context,
      everCallback: (notifier, listenerInstance) {
        if (notifier is LoginController) {
          if (notifier.hasInfo) {
            if(mounted) {
              Messages.of(context).showInfo(notifier.infoMessage!);
            }
          }
        }        
      },
      sucessCallback: (notifier, listenerInstance) {
        if(mounted) {
        Logger().i('Usuário logado');          
        }
      },
    );
  }

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
                        key: _formKey,
                        child: Column(
                          children: [
                            OrganizameTextformfield(
                              label: 'E-mail',
                              controller: _emailEC,
                              focusNode: _emailFN,
                              validator: Validatorless.multiple([
                                Validatorless.required('Campo obrigatório'),
                                Validatorless.email('E-mail inválido'),
                              ]),
                              obscureText: false,
                            ),
                            const SizedBox(height: 20),
                            OrganizameTextformfield(
                              label: 'Senha',
                              controller: _passwordEC,
                              validator: Validatorless.multiple([
                                Validatorless.required('Campo obrigatório'),
                                Validatorless.min(6, 'Senha muito curta'),
                                Validatorless.max(12, 'Senha muito longa'),
                              ]),
                              obscureText: true,
                            ),
                            const SizedBox(height: 30),
                            OrganizameElevatedButton(
                              label: 'Entrar',
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<LoginController>().login(
                                        _emailEC.text,
                                        _passwordEC.text,
                                      );
                                }
                              },
                            ),
                            const SizedBox(height: 10),
                            TextButton(
                              onPressed: () {
                                if (_emailEC.text.isNotEmpty) {
                                  context
                                      .read<LoginController>()
                                      .resetPassword(_emailEC.text);
                                } else {
                                  _emailFN.requestFocus(); // Foca no campo de e-mail
                                  Messages.of(context).showError(
                                    'Informe o e-mail para recuperação',
                                  );
                                }
                              },
                              style: TextButton.styleFrom(
                                foregroundColor:
                                    Theme.of(context).colorScheme.secondary,
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
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: SizedBox(
                              width: double
                                  .infinity, // Define a largura como infinita para ocupar o máximo possível
                              child: SignInButton(
                                Buttons.Google,
                                text: 'Continue com o Google',
                                padding: const EdgeInsets.all(5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                onPressed: () {
                                  context.read<LoginController>().loginGoogle();
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Não tem uma conta?'),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamed('/register');
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor:
                                      Theme.of(context).colorScheme.secondary,
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
