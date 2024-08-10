import 'package:flutter/material.dart';

class Validators {
  Validators._();// private constructor que não permite instanciar a classe, ou seja, 

  //método que retorna um FormFieldValidator que recebe uma mensagem e um valor
  static FormFieldValidator compare(String message, TextEditingController? valueEC) {
    return (value) {
      final valueCompare = valueEC?.text ?? '';
      if(value == null || (value != null && value != valueCompare)) {
        return message;}
    };
  }
}