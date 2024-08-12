// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:organizame/app/core/Widget/organizame_logger.dart';
import 'package:organizame/app/core/exception/auth_exception.dart';
import './user_repository.dart';

class UserRepositoryImpl extends UserRepository {
  final FirebaseAuth _firebaseAuth;

  UserRepositoryImpl({
    required FirebaseAuth firebaseAuth,
  }) : _firebaseAuth = firebaseAuth;

  @override
  Future<User?> register(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e, s) {
      OrganizameLogger.logError(e, s);
      //e-mail-already-exists
      if (e.code == 'email-already-in-use') {
        OrganizameLogger.i('A conta já existe para esse e-mail.');
        final loginTypes =
            await _firebaseAuth.fetchSignInMethodsForEmail(email);

        if (loginTypes.contains('password')) {
          throw AuthException(message: 'O e-mail já está cadastrado.');
        } else {
          throw AuthException(
              message: 'O e-mail já está cadastrado com outra forma de login.');
        }
      } else {
        throw AuthException(message: 'Erro ao criar a conta.');
      }
    }
  }

  @override
  Future<User?> login(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user;
    } on PlatformException catch (e, s) {
      OrganizameLogger.logError(e, s);
      if (e.code == 'user-not-found') {
        throw AuthException(message: 'Usuário não encontrado.');
      } else if (e.code == 'wrong-password') {
        throw AuthException(message: 'Senha incorreta.');
      } else {
        throw AuthException(message: 'Erro ao fazer login.');
      }
    } on FirebaseAuthException catch (e, s) {
      OrganizameLogger.logError(e, s);
      throw AuthException(message: 'Erro ao fazer login.');
    }
  }
}
