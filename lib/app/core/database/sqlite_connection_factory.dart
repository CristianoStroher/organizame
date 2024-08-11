import 'package:organizame/app/core/database/sqlite_migration_factory.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';


/* Nota 1*/

class SqliteConnectionFactory {
  /* Nota 4*/
  static const _databaseName = 'my_database.db';
  static const int _databaseVersion = 1;

  /* Nota 6*/
  Database? _db;
  final _lock = Lock();

  /*Nota 2*/
  static SqliteConnectionFactory? _instance;

  SqliteConnectionFactory._();

  /* Nota 3*/
  factory SqliteConnectionFactory() {
    _instance ??= SqliteConnectionFactory._();
    return _instance!;
  }

  /* Nota 5*/
   Future<Database> openConnection() async {
    await _lock.synchronized(() async {
      if (_db == null) {
        final databasePath = await getDatabasesPath();
        final databasePathFinal = join(databasePath, _databaseName);
        _db = await openDatabase(
          databasePathFinal,
          version: _databaseVersion,
          onConfigure: _onConfigure,
          onCreate: _onCreate,
          onUpgrade: _onUpgrade,
          onDowngrade: _onDowngrade,
        );
      }
    });
    return _db!;
  }

  Future<void> closeConnection() async {
    await _lock.synchronized(() async {
      if (_db != null) {
        await _db!.close();
        _db = null;
      }
    });
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  // Future<void> _onCreate(Database db, int version) async {
  //   final batch = db.batch();
  //   final migrations = SqliteMigrationFactory().getCreateMigrations();
  //   migrations.forEach((m) => m.create(batch));
  //   batch.commit();
  // }

  Future<void> _onCreate(Database db, int version) async {
    final batch = db.batch();
    final migrations = SqliteMigrationFactory().getCreateMigrations();
    for (var migration in migrations) {
      migration.create(batch);
    }
    await batch.commit();
  }


  /* Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    final batch = db.batch();
    final migrations = SqliteMigrationFactory().getUpgradeMigrations(oldVersion);
    migrations.forEach((m) => m.update(batch));
    batch.commit();
  } */

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    final batch = db.batch();
    final migrations = SqliteMigrationFactory().getUpgradeMigrations(oldVersion);
    for (var migration in migrations) {
      migration.update(batch);
    }
    await batch.commit();
  }

  Future<void> _onDowngrade(Database db, int oldVersion, int newVersion) async {}

}
