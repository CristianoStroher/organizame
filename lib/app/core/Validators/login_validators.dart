class LoginValidators {

  static final LoginValidators instance = LoginValidators._();
  
  LoginValidators._();


  String getPasswordCriteriaMessage() {
    return 'A senha deve atender aos seguintes critérios:\n'
           '- Ter entre 6 e 12 caracteres\n'
           '- Contém pelo menos uma letra maiúscula\n'
           '- Contém pelo menos um dígito\n'
           '- Contém pelo menos um caractere especial';
  }

  String validatePassword(String password) {
    final RegExp hasUpperCase = RegExp(r'[A-Z]');
    final RegExp hasDigits = RegExp(r'\d');
    final RegExp hasSpecialCharacters = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
    
    bool isValidLength = password.length >= 6 && password.length <= 12;
    bool hasUpper = hasUpperCase.hasMatch(password);
    bool hasDigit = hasDigits.hasMatch(password);
    bool hasSpecial = hasSpecialCharacters.hasMatch(password);

    if (isValidLength && hasUpper && hasDigit && hasSpecial) {
      return ''; // Senha válida
    } else {
      return getPasswordCriteriaMessage(); // Retorna mensagem com regras gerais
    }
  }
}
