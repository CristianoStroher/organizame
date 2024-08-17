// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:organizame/app/core/navigator/organizame_navigator.dart';

import 'package:organizame/app/services/user_service.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth;
  final UserService _userService;

  AuthProvider({
    required FirebaseAuth firebaseAuth,
    required UserService userService,
  })  : _firebaseAuth = firebaseAuth,
        _userService = userService;

  // um atalho para acessar o método _userService.register
  Future<void> logout() => _userService.logout();

  // metodo para pegar o usuário atual
  User? get user => _firebaseAuth.currentUser;

  // metodo para escutar o usuário atual
  void loadListener() {
    _firebaseAuth.userChanges().listen((_) => notifyListeners());
    _firebaseAuth.idTokenChanges().listen((user) {
      if (user != null) {
        OrganizameNavigator.to
            .pushNamedAndRemoveUntil('/home', (route) => false);
      } else {
        OrganizameNavigator.to
            .pushNamedAndRemoveUntil('/login', (route) => false);
      }
    });
  }
}
