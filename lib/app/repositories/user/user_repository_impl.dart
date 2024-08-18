// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:logger/logger.dart';

import 'package:organizame/app/core/Widget/organizame_logger.dart';
import 'package:organizame/app/core/exception/auth_exception.dart';
import 'package:organizame/app/repositories/user/user_repository.dart';

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

  @override
  Future<void> resetPassword(String email) async {
    try {
      final checkEmail = await _firestore
          .collection("users")
          .where("email", isEqualTo: email)
          .get(); //verifica se o email existe

      if (checkEmail.docs.isEmpty) {
        throw AuthException(message: 'E-mail não cadastrado.');
      } else {
        await _firebaseAuth.sendPasswordResetEmail(email: email);
      }
    } on PlatformException catch (e, s) {
      Logger().e(e.message);
      Logger().e(s.toString());
      throw AuthException(message: e.message ?? 'Erro ao recuperar senha');
    }
  }

  @override
  Future<User?> googleLogin() async {
    List<String> loginMethods;
    try {
      final googleSignIn = GoogleSignIn(); // Instancia o GoogleSignIn
      final googleUser =
          await googleSignIn.signIn(); // Abre a tela de login do Google
      if (googleUser != null) {
        // Verifica se o usuário não cancelou o login
        loginMethods = await _firebaseAuth.fetchSignInMethodsForEmail(
            googleUser.email); // Verifica se o e-mail já está cadastrado
        if (loginMethods.contains('password')) {
          // Verifica se o e-mail já está cadastrado com senha
          throw AuthException(
              message: 'O e-mail já está cadastrado com outra forma de login.');
        } else {
          final googleAuth = await googleUser.authentication;
          final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );

          final userCredential =
              await _firebaseAuth.signInWithCredential(credential);
          return userCredential.user;
        }
      }
    } on FirebaseAuthException catch (e, s) {
      Logger().e(e.message);
      Logger().e(s.toString());
      if (e.code == 'account-exists-with-different-credential') {
        throw AuthException(
            message: 'O e-mail já está cadastrado com outra forma de login.');
      } else {
        throw AuthException(message: 'Erro ao fazer login com o Google.');
      }
    }

    return null;
  }

  @override
  Future<void> logout() async {
    await GoogleSignIn().signOut();
    await _firebaseAuth.signOut();
  }
  
  @override
  Future<void> updateDisplayName(String name) async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      await user.updateDisplayName(name);
      user.reload();
    }    
  }

  
}
