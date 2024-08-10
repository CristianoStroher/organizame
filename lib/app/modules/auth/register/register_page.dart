import 'package:flutter/material.dart';
import 'package:organizame/app/core/Widget/organizame_elevatebutton.dart';
import 'package:organizame/app/core/Widget/organizame_logo.dart';
import 'package:organizame/app/core/Widget/organizame_textformfield.dart';
import 'package:organizame/app/core/ui/theme_extensions.dart';
import 'package:validatorless/validatorless.dart';

class RegisterPage extends StatefulWidget {

  
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final _globalKey = GlobalKey<FormState>();
  // variáveis para controlar os campos de texto
  final nomeEC = TextEditingController();
  final emailEC = TextEditingController();
  final passwordEC = TextEditingController();
  final confirmPasswordEC = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    nomeEC.dispose();
    emailEC.dispose();
    passwordEC.dispose();
    confirmPasswordEC.dispose();
  }

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
                label: 'Nome',
                obscureText: false,
                controller: nomeEC,
                validator: Validatorless.multiple([
                  Validatorless.required('Campo obrigatório'),
                  Validatorless.min(3, 'Nome muito curto'),
                ]),
                ),
              const SizedBox(height: 20),
              OrganizameTextformfield(
                label: 'E-mail',
                obscureText: false,
                controller: emailEC,
                validator: Validatorless.multiple([
                  Validatorless.required('Campo obrigatório'),
                  Validatorless.email('E-mail inválido'),
                ]),
                ),
              const SizedBox(height: 20),
              OrganizameTextformfield(
                label: 'Senha',
                obscureText: true,
                controller: passwordEC,
                validator: (value) {
                if (value == null || value.isEmpty) return 'Campo obrigatório';
                final password = value;
                final hasUpperCase = RegExp(r'[A-Z]').hasMatch(password);
                final hasDigits = RegExp(r'\d').hasMatch(password);
                final hasSpecialCharacters = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);
                
                if (password.length < 6) return 'Senha muito curta';
                if (password.length > 12) return 'Senha muito longa';
                if (!hasUpperCase) return 'Deve conter uma letra maiúscula';
                if (!hasDigits) return 'Deve conter um número';
                if (!hasSpecialCharacters) return 'Deve conter um caractere especial';
                
                return null;
              },
                ),
              const SizedBox(height: 20),
              OrganizameTextformfield(
                label: 'Confirmar Senha',
                obscureText: true,
                controller: confirmPasswordEC,
                validator: Validatorless.multiple([
                  Validatorless.required('Campo obrigatório'),
                  Validatorless.compare(passwordEC, 'Senhas não conferem'),
                ]),
                ),
              const SizedBox(height: 30),
              OrganizameElevatedButton(
                label: 'Cadastrar',
                onPressed: () {
                  if (_globalKey.currentState!.validate()) {
                    // Chamar o método de cadastro
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
