import 'package:firebase_auth/firebase_auth.dart';
import 'package:organizame/app/core/validators/login_validators.dart';
import 'package:organizame/app/repositories/user/user_repository.dart';
import 'user_service.dart';

class UserServiceImpl extends UserService {
  final UserRepository _userRepository;
  final LoginValidators _loginValidators;

  UserServiceImpl(
      {required UserRepository userRepository,
      required LoginValidators loginValidators})
      : _userRepository = userRepository,
        _loginValidators = loginValidators;

  @override
  Future<User?> register(String email, String password, String nome) async {
    final errorMessage = _loginValidators.validatePassword(password);
    if (errorMessage.isNotEmpty) {
      throw Exception(errorMessage);
    }
    return _userRepository.register(email, password, nome);
  }

  @override
  Future<User?> login(String email, String password) =>
      _userRepository.login(email, password);

  @override
  Future<void> resetPassword(String email) =>
      _userRepository.resetPassword(email);

  @override
  Future<User?> googleLogin() async {
    return await _userRepository.googleLogin();
  }

  @override
  Future<void> logout() => _userRepository.logout();

  @override
  Future<void> updateDisplayName(String name) =>
      _userRepository.updateDisplayName(name);
}
