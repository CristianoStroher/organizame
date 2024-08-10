class OrgaznizameValidation {

  bool isValidPassword(String password) {
    final RegExp hasUpperCase = RegExp(r'[A-Z]');
    final RegExp hasDigits = RegExp(r'\d');
    final RegExp hasSpecialCharacters = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
    
    return password.length >= 6 &&
           password.length <= 12 &&
           hasUpperCase.hasMatch(password) &&
           hasDigits.hasMatch(password) &&
           hasSpecialCharacters.hasMatch(password);
  }
}