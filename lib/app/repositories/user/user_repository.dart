
import 'package:firebase_auth/firebase_auth.dart';

abstract class UserRepository {

  Future<User?> register(String email, String password, String nome); // adicionado
  Future<User?> login(String email, String password);
  Future<void> resetPassword(String email);
  Future<User?> googleLogin();
  Future<void> logout();
  Future<void> updateDisplayName(String name);  



  
}