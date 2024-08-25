import 'package:organizame/app/core/database/sqlite_connection_factory.dart';

import './tasks_repository.dart';

class TasksRepositoryImpl extends TasksRepository {
  final SqliteConnectionFactory _sqLiteConnectionFactory;

  TasksRepositoryImpl(
      {required SqliteConnectionFactory sqLiteConnectionFactory})
      : _sqLiteConnectionFactory = sqLiteConnectionFactory;

  @override
  Future<void> saveTask(DateTime date, DateTime time, String description,
      {String? observations}) async {
    final connection = await _sqLiteConnectionFactory.openConnection();
    await connection.insert('compromisso', {
      'id': null,
      'descricao': description,
      'data': date.toIso8601String(),
      'hora': time.toIso8601String(),
      'observacao': observations,
      'finalizado': 0
    });
  }


}


