import 'package:flutter/material.dart';

class Validators {
  Validators._();// private constructor que não permite instanciar a classe, ou seja, 

 // Método que retorna um FormFieldValidator que recebe uma mensagem e um valor
  static FormFieldValidator<String?> compare(String message, TextEditingController? valueEC) {
    return (value) {
      final valueCompare = valueEC?.text ?? '';
      if (value == null || value != valueCompare) {
        return message; // Retorna a mensagem se a validação falhar
      }
      return null; // Retorna null se a validação for bem-sucedida
    };
  }
}