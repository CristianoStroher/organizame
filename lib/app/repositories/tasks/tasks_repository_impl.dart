import 'package:organizame/app/core/database/sqlite_connection_factory.dart';
import 'package:organizame/app/models/task_object.dart';
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

  @override
  Future<List<TaskObject>> findByPeriod(DateTime start, DateTime end) async {
    final startfilter = DateTime(start.year, start.month, start.day, 0, 0, 0);
    final endFilter = DateTime(end.year, end.month, end.day, 23, 59, 59);

    final conn = await _sqLiteConnectionFactory.openConnection();
    final result = await conn.rawQuery(
      '''
        SELECT * FROM
        compromisso
        WHERE data BETWEEN ? AND ?
        ORDER BY data''',
      [startfilter.toIso8601String(), endFilter.toIso8601String()],
    );

    return result.map((e) => TaskObject.fromMap(e)).toList();
  }

  @override
  Future<bool> deleteTask(TaskObject task) {
    final conn = _sqLiteConnectionFactory.openConnection();

    return conn.then((value) async {
      final result = await value.delete(
        'compromisso',
        where: 'id = ?',
        whereArgs: [task.id],
      );

      return result > 0;
    });
  }
}
