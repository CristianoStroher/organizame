import 'package:organizame/app/core/database/migrations/migration.dart';
import 'package:organizame/app/core/database/migrations/migration_v1.dart';

/* Nota 7 */

class SqliteMigrationFactory {

  List<Migration> getCreateMigrations() => [
    MigrationV1(),
  ];

  List<Migration> getUpgradeMigrations(int version) => [];
  // Adicionar o método abaixo para ataulização de versão e comentar a linha acima
  // List<Migration> getUpgradeMigrations(int version) {
  //   final migrations = <Migration>[];
  //   if (version == 1) {
  //     migrations.add(MigrationV1());
  //   }
  //   return migrations;
  // }
  

}