import 'package:firebase_auth/firebase_auth.dart';

abstract class UserService {

  Future<User?> register(String email, String password, String nome); //adicionado
  Future<User?> login(String email, String password);
  Future<void> resetPassword(String email);

}