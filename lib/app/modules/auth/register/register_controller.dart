import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:organizame/app/core/exception/auth_exception.dart';
import 'package:organizame/app/services/user_service.dart';

class RegisterController extends ChangeNotifier {
  final UserService _userService;
  String? error;
  bool sucess = false;

  RegisterController({required UserService userService})
      : _userService = userService;

  Future<void> registerUser(String email, String password) async {
    try {
      error = null;
      sucess = false;
      notifyListeners();

      final user = await _userService.register(email, password);
      if (user != null) {
        sucess = true;
        Logger().i('Usuário cadastrado com sucesso');
      } else {
        error = 'Erro ao cadastrar usuário';
        Logger().e('Erro ao cadastrar usuário');
      }
    } on AuthException catch (e) {
      error = e.message;
      Logger().e('Erro ao cadastrar usuário: ${e.message}');
    } finally {
      notifyListeners();
    }
  }
}
