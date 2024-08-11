
import 'package:flutter/material.dart';

class DefautChangeNotifer extends ChangeNotifier {
  
  bool _loading = false;
  String? _error;
  bool _sucess = false;

  bool get isLoading => _loading;
  String? get error => _error;
  bool get hasError => _error != null;
  bool get isSucess => _sucess;
  
  void showLoading() => _loading = true;
  void hideLoading() => _loading = false;
  void sucess() => _sucess = true;
  void setError(String? error) => _error = error;
  void showLoadingAndReset() {
    showLoading();
    resetState();
  }

  void resetState() {
    _error = null;
    _sucess = false;
  }



  
}