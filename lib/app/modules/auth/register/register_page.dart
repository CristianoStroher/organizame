

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:validatorless/validatorless.dart';

import 'package:organizame/app/core/Validators/login_validators.dart';
import 'package:organizame/app/core/widget/organizame_elevatebutton.dart';
import 'package:organizame/app/core/widget/organizame_logo.dart';
import 'package:organizame/app/core/widget/organizame_textformfield.dart';
import 'package:organizame/app/core/notifier/defaut_listener_notifier.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';
import 'package:organizame/app/modules/auth/register/register_controller.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _globalKey = GlobalKey<FormState>();
  final _nomeEC = TextEditingController();
  final _emailEC = TextEditingController();
  final _passwordEC = TextEditingController();
  final _confirmPasswordEC = TextEditingController();
  final _loginValidators = LoginValidators.instance;

  RegisterController? _registerController;

  @override
  void initState() {
    super.initState();
    final defaultListener = DefaultListenerNotifier (changeNotifier: context.read<RegisterController>());
    defaultListener.listener(
      context: context,
      sucessCallback: (notifier, listenerInstance) {
        listenerInstance.dispose();
        // Navigator.of(context).pop(); // trocado visto a alteração do auth_provider
      } );
      
    
  }

  @override
  void dispose() {    
    _nomeEC.dispose();
    _emailEC.dispose();
    _passwordEC.dispose();
    _confirmPasswordEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: context.scaffoldBackgroundColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
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
      body: Form(
        key: _globalKey,
        child: SingleChildScrollView(
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
              OrganizameTextformfield(
                enabled: true,
                label: 'Nome',
                obscureText: false,
                controller: _nomeEC,
                validator: Validatorless.multiple([
                  Validatorless.required('Campo obrigatório'),
                  Validatorless.min(3, 'Nome muito curto'),
                ]),
              ),
              const SizedBox(height: 20),
              OrganizameTextformfield(
                enabled: true,
                label: 'E-mail',
                obscureText: false,
                controller: _emailEC,
                validator: Validatorless.multiple([
                  Validatorless.required('Campo obrigatório'),
                  Validatorless.email('E-mail inválido'),
                ]),
              ),
              const SizedBox(height: 20),
              OrganizameTextformfield(
                enabled: true,
                label: 'Senha',
                obscureText: true,
                controller: _passwordEC,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório';
                  }
                  final errorMessage = _loginValidators.validatePassword(value);
                  return errorMessage.isEmpty ? null : errorMessage;
                },
              ),
              const SizedBox(height: 20),
              OrganizameTextformfield(
                enabled: true,
                label: 'Confirmar Senha',
                obscureText: true,
                controller: _confirmPasswordEC,
                validator: Validatorless.multiple([
                  Validatorless.required('Campo obrigatório'),
                  Validatorless.compare(_passwordEC, 'Senhas não conferem'),
                ]),
              ),
              const SizedBox(height: 30),
              OrganizameElevatedButton(
                label: 'Cadastrar',
                onPressed: () {
                  final formValid =
                      _globalKey.currentState?.validate() ?? false;
                  if (formValid) {
                    final nome = _nomeEC.text;
                    final email = _emailEC.text;
                    final password = _passwordEC.text;
                    context
                        .read<RegisterController>()
                        .registerUser(email, password, nome);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
