import 'package:firebase_auth/firebase_auth.dart';
import 'package:organizame/app/core/Validators/login_validators.dart';
import 'package:organizame/app/repositories/user/user_repository.dart';
import './user_service.dart';

class UserServiceImpl extends UserService {

  final UserRepository _userRepository;
  final LoginValidators _loginValidators;

  UserServiceImpl({
    required UserRepository userRepository,
    required LoginValidators loginValidators})
      : _userRepository = userRepository,
        _loginValidators = loginValidators;
   
  @override
  Future<User?> register(String email, String password) async {
    if (!_loginValidators.isValidPassword(password)) {
      throw Exception('Password does not meet the requirements.');
    }
    return _userRepository.register(email, password);
  }


}

