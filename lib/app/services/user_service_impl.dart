import 'package:firebase_auth/firebase_auth.dart';
import 'package:organizame/app/core/Widget/orgaznizame_validation.dart';
import 'package:organizame/app/repositories/user/user_repository.dart';
import './user_service.dart';

class UserServiceImpl extends UserService {

  final UserRepository _userRepository;
  final OrgaznizameValidation _organizameValidation;

  UserServiceImpl({
    required UserRepository userRepository,
    required OrgaznizameValidation organizameValidation})
      : _userRepository = userRepository,
        _organizameValidation = organizameValidation;
   
  @override
  Future<User?> register(String email, String password) async {
    if (!_organizameValidation.isValidPassword(password)) {
      throw Exception('Password does not meet the requirements.');
    }
    return _userRepository.register(email, password);
  }


}

