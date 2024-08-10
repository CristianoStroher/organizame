
import 'package:logger/logger.dart';

class OrganizameLogger {
  
  static final Logger _logger = Logger(
    filter:ProductionFilter(),
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 50,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),     
    


  );

   static void logError(dynamic error, StackTrace stackTrace) {
    // Registra a mensagem de erro
    _logger.e("Error: $error");
    // Registra o stack trace separadamente
    _logger.e("StackTrace: $stackTrace");
  }

  // Função para log de informações
  static void i(String message) {
    _logger.i(message);
  }

  // Função para log de avisos
  static void w(String message) {
    _logger.w(message);
  }

  // Função para log de mensagens de debug
  static void d(String message) {
    _logger.d(message);
  }
}



