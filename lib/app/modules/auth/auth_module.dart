
import 'package:organizame/app/core/Validators/login_validators.dart';
import 'package:organizame/app/core/modules/organizame_module.dart';
import 'package:organizame/app/modules/auth/login/login_controller.dart';
import 'package:organizame/app/modules/auth/login/login_page.dart';
import 'package:organizame/app/modules/auth/register/register_controller.dart';
import 'package:organizame/app/modules/auth/register/register_page.dart';
import 'package:provider/provider.dart';

class AuthModule extends OrganizameModule {
  AuthModule()
      : super(
          bindings: [
            Provider(create: (_) => LoginValidators.instance), //injetando a instância da classe de validação de login
            ChangeNotifierProvider(create: (_) => LoginController(), //injetando o controller da tela de login
            ),
            ChangeNotifierProvider(create: (context) => RegisterController(userService: context.read()), //injetando o controller da tela de login
            ),
          ],
          router: {
            '/login': (context) => const LoginPage(),
            '/register': (context) => const RegisterPage(),
          },
        );
  
}