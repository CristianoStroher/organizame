import 'package:logger/logger.dart';
import 'package:organizame/app/core/exception/auth_exception.dart';
import 'package:organizame/app/core/notifier/defaut_change_notifer.dart';
import 'package:organizame/app/services/user_service.dart';

class LoginController extends DefautChangeNotifer {
  final UserService _userService;

  LoginController({
    required UserService userService,
  }) : _userService = userService;

  Future<void> login(String email, String password) async {
    try {
      showLoadingAndReset();
      notifyListeners();
      final user = await _userService.login(email, password);
      if (user != null) {
        Logger().i('Usuário logado: ${user.email}');
        sucess();
      }else{
        Logger().e('Erro ao fazer login');
        setError('Erro ao fazer login');
      }
    } on AuthException catch (e) {
      Logger().e(e.message);
      setError(e.message);
    } finally {
      hideLoading();
      notifyListeners();
    }
  }
}
