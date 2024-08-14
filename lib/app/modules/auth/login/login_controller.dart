import 'package:logger/logger.dart';
import 'package:organizame/app/core/exception/auth_exception.dart';
import 'package:organizame/app/core/notifier/defaut_change_notifer.dart';
import 'package:organizame/app/services/user_service.dart';

class LoginController extends DefautChangeNotifer {
  final UserService _userService;
  String? infoMessage; // variável para exibir mensagem de erro

  LoginController({
    required UserService userService,
  }) : _userService = userService;

  bool get hasInfo =>
      infoMessage != null; // verifica se a mensagem de erro é nula

  Future<void> login(String email, String password) async {
    try {
      showLoadingAndReset();
      infoMessage = null;
      notifyListeners();
      final user = await _userService.login(email, password);
      if (user != null) {
        Logger().i('Usuário logado: ${user.email}');
        sucess();
      } else {
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

  Future<void> resetPassword(String email) async {
    try {
      showLoadingAndReset();
      infoMessage = null;
      notifyListeners();
      await _userService.resetPassword(email);
      infoMessage = 'E-mail enviado para redefinição de senha';
    } on AuthException catch (e) {
      setError(e.message);
    } catch (e) {
      setError('Erro ao resetar a senha');
    } finally {
      hideLoading();
      notifyListeners();
    }
  }
}
