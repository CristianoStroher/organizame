
import 'package:logger/logger.dart';
import 'package:organizame/app/core/exception/auth_exception.dart';
import 'package:organizame/app/core/notifier/defaut_change_notifer.dart';
import 'package:organizame/app/services/user_service.dart';


class RegisterController extends DefautChangeNotifer {
  final UserService _userService;
  
  RegisterController({required UserService userService})
      : _userService = userService;

  Future<void> registerUser(String email, String password, String nome) async { // adicionado
    try {
      showLoadingAndResetState();
      notifyListeners();

      final user = await _userService.register(email, password, nome); // adicionado
      if (user != null) {
        success();
        Logger().i('Usuário cadastrado com sucesso');
      } else {
        setError('Erro ao cadastrar usuário');
        Logger().e('Erro ao cadastrar usuário');
      }
    } on AuthException catch (e) {
      setError(e.message);
      Logger().e('Erro ao cadastrar usuário: ${e.message}');
    } finally {
      hideLoading();
      notifyListeners();
    }
  }
}
