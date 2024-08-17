
import 'package:flutter/material.dart';

class OrganizameNavigator {

  OrganizameNavigator._();

  static final navigatorKey = GlobalKey<NavigatorState>();

  // é uma forma de acessar o navigator de qualquer lugar da aplicação
  static NavigatorState get to => navigatorKey.currentState!;


  
  
}