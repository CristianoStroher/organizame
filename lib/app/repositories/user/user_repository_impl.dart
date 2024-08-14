// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

import 'package:organizame/app/core/Widget/organizame_logger.dart';
import 'package:organizame/app/core/exception/auth_exception.dart';
import './user_repository.dart';

class UserRepositoryImpl extends UserRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore; // adicionado

  UserRepositoryImpl({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore, // adicionado
  })  : _firebaseAuth = firebaseAuth,
        _firestore = firestore; // adicionado

  @override
  Future<User?> register(String email, String password, String nome) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user != null) {
        // Adiciona o nome e o email no Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'email': email,
          'name': nome, // Adiciona o nome do usuário
        });
      }

      return user;
    } on FirebaseAuthException catch (e, s) {
      OrganizameLogger.logError(e, s);
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
    } on FirebaseAuthException catch (e, s) {
      OrganizameLogger.logError(e, s);
      if (e.code == 'invalid-credential') {
        throw AuthException(message: 'Usuário não encontrado.');
      } else if (e.code == 'wrong-password') {
        throw AuthException(message: 'Senha incorreta.');
      } else {
        throw AuthException(message: 'Erro ao fazer login.');
      }
    } catch (e, s) {
      OrganizameLogger.logError(e, s);
      throw AuthException(message: 'Erro inesperado ao fazer login.');
    }
  }


//   @override
// Future<void> resetPassword(String email) async {
//   try {
//     // final loginMethods = await _firebaseAuth.fetchSignInMethodsForEmail(email);
//     final loginMethods = await _firebaseAuth.sendPasswordResetEmail(email: email);

//     if (loginMethods.contains('password')) {
//       await _firebaseAuth.sendPasswordResetEmail(email: email);
//     } else if (loginMethods.contains('google')) {
//       throw AuthException(message: 'E-mail cadastrado com o Google. Redefinição de senha não disponível.');
//     } else {
//       throw AuthException(message: 'E-mail não cadastrado.');
//     }
//   } on PlatformException catch (e, s) {
//     Logger().e(e.message);
//     Logger().e(s);
//     throw AuthException(message: 'Erro ao resetar a senha.');
//   }
// }
@override
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      // Informe o usuário que um e-mail foi enviado
      // Nota: Por razões de segurança, não especifique se o e-mail está registrado
    } catch (e) {
      if (e is FirebaseAuthException) {
        throw AuthException(message: 'Erro ao resetar a senha.');
      } else {
        throw AuthException(message: 'Erro inesperado ao resetar a senha.');
      }
    }
  }

}
