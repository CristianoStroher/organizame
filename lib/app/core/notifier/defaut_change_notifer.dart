
// import 'package:flutter/material.dart';

// class DefautChangeNotifer extends ChangeNotifier {
  
//   bool _loading = false;
//   String? _error;
//   bool _sucess = false;

//   bool get isLoading => _loading;
//   String? get error => _error;
//   bool get hasError => _error != null;
//   bool get isSucess => _sucess;
  
//   void showLoading() => _loading = true;
//   void hideLoading() => _loading = false;
//   void sucess() => _sucess = true;
//   void setError(String? error) => _error = error;
//   void showLoadingAndReset() {
//     showLoading();
//     resetState();
//   }

//   void resetState() {
//     setError(null);
//     _sucess = false;
//   }



  
// }

import 'package:flutter/material.dart';

class DefautChangeNotifer extends ChangeNotifier{
  bool _loading = false; //atributo para armazenar se esta carregando
  String? _error; // atributo opcional para armazenar o erro 
  bool _success = false; //atributo para armazenar se a operação foi bem sucedida

  //metodos
  bool get loading => _loading; //metodo get para retornar o valor de loading
  String? get error => _error; //metodo get para retornar o valor de error
  bool get isSuccess => _success; //metodo get para retornar o valor de success
  bool get hasError => _error != null; //metodo get para retornar se tem erro

  void showLoading() => _loading = true; //metodo para mostrar o loading
  void hideLoading() => _loading = false; //metodo para esconder o loading
  void success() => _success = true; //metodo para mostrar que a operação foi bem sucedida
  void setError(String? message) => _error = error; //metodo para setar o erro
  void showLoadingAndResetState() {
    showLoading(); //mostra o loading
    resetState();// reseta o estado colocando o erro como nulo e o sucesso como falso
  }

  //metodo para resetar o estado
  void resetState() {
    setError(null); //reseta o erro
    _success = false; //reseta o sucesso
  }


}