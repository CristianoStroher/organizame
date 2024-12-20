import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
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
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);
    final formattedTime = DateFormat('HH:mm:ss').format(time);

    await connection.insert('compromisso', {
      'id': null,
      'descricao': description,
      'data': formattedDate,
      'hora': formattedTime,
      'observacao': observations,
      'finalizado': 0
    });
  }

  @override
  Future<List<TaskObject>> findByPeriod(DateTime start, DateTime end) async {
    final startFilter = DateTime(start.year, start.month, start.day, 0, 0, 0);
    final endFilter = DateTime(end.year, end.month, end.day, 23, 59, 59);

    // Logs de depuração
    final formattedStartFilter = DateFormat('yyyy-MM-dd').format(startFilter);
    final formattedEndFilter = DateFormat('yyyy-MM-dd').format(endFilter);
    

    final conn = await _sqLiteConnectionFactory.openConnection();
    final result = await conn.rawQuery(
      '''
        SELECT * FROM
        compromisso
        WHERE data BETWEEN ? AND ?
        ORDER BY data''',
      [
        DateFormat('yyyy-MM-dd').format(startFilter),
        DateFormat('yyyy-MM-dd').format(endFilter),
      ],
    );
    try {
      return result.map((e) => TaskObject.fromMap(e)).toList();
    } catch (e) {
      throw Exception('Erro ao buscar tarefas');
      return [];
    }
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

  @override
  Future<TaskObject?> findTask(TaskObject task) async {
    final conn = _sqLiteConnectionFactory.openConnection();
    final result = conn.then((value) async {
      final result = await value.query(
        'compromisso',
        where: 'id = ?',
        whereArgs: [task.id],
      );
      return result.isNotEmpty ? TaskObject.fromMap(result.first) : null;
    });
  }

  @override
  Future<void> finishTask(TaskObject task) async {
    final conn = await _sqLiteConnectionFactory.openConnection();

    final finished = task.finalizado ? 1 : 0;

    await conn.rawUpdate('''
      UPDATE compromisso
      SET finalizado = ?
      WHERE id = ?
    ''', [finished, task.id]);
  }

  @override
  Future<void> updateTask(TaskObject task) async {
    try {
      final conn = await _sqLiteConnectionFactory.openConnection();

      Logger().i('Atualizando tarefa com ID: ${task.id}');
      Logger().i('Dados da tarefa: ${task.toMap()}');

      await conn.update(
        'compromisso',
        task.toMap(),
        where: 'id = ?',
        whereArgs: [task.id],
      );
    } catch (e) {
      Logger().e('Erro ao atualizar a tarefa: $e');
      throw Exception('Erro ao atualizar tarefa: $e');
    }
  }

  @override
  Future<List<TaskObject>> getOldTasks({DateTime? startDate, DateTime? endDate}) async {
    try {
      final conn = await _sqLiteConnectionFactory.openConnection();
      
      String query = '''
        SELECT * FROM compromisso
        WHERE 1=1
      ''';
      
      List<dynamic> arguments = [];

      if (startDate != null) {
        query += ' AND date(data) >= date(?)';
        arguments.add(DateFormat('yyyy-MM-dd').format(startDate));
      }

      if (endDate != null) {
        query += ' AND date(data) <= date(?)';
        arguments.add(DateFormat('yyyy-MM-dd').format(endDate));
      }

      query += ' ORDER BY data DESC, hora DESC';

      Logger().d('Query: $query');
      Logger().d('Arguments: $arguments');

      final result = await conn.rawQuery(query, arguments);
      
      Logger().d('Resultados encontrados: ${result.length}');

      return result.map((e) => TaskObject.fromMap(e)).toList();
    } catch (e) {
      Logger().e('Erro ao buscar tarefas antigas: $e');
      throw Exception('Erro ao buscar tarefas antigas: $e');
    }
  }

}
