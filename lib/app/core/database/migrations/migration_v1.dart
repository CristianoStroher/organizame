import 'package:organizame/app/core/database/migrations/migration.dart';
import 'package:sqflite_common/sqlite_api.dart';

class MigrationV1 implements Migration {

  @override
  void create(Batch batch) {
    batch.execute('''
      CREATE TABLE compromisso (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        descricao VARCHAR(255) NOT NULL,
        data DATE NOT NULL,
        hora TIME NOT NULL,
        observacao TEXT,
        finalizado INTEGER
      )
    ''');
    batch.execute('''
      CREATE TABLE visita (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        data DATE NOT NULL,
        nome VARCHAR(255) NOT NULL,
        total_metragem DOUBLE,
        telefone VARCHAR(20),
        endereco VARCHAR(255)             
    ''');
    
     batch.execute('''
      CREATE TABLE ambiente (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        visita_id INTEGER NOT NULL,
        tipo VARCHAR(50) NOT NULL,
        descricao VARCHAR(255),
        area DOUBLE,
        preco DOUBLE,
        exigencia VARCHAR(50),
        observacao TEXT,
        FOREIGN KEY(visita_id) REFERENCES visita(id) ON DELETE CASCADE
      )
    ''');    

    batch.execute('''
      CREATE TABLE quarto_casal (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        ambiente_id INTEGER NOT NULL,
        exigencia VARCHAR(50),
        roupas BOOLEAN,
        calçados BOOLEAN,
        maquiagem BOOLEAN,
        roupas_cama BOOLEAN,
        acessorios BOOLEAN,
        outros BOOLEAN,
        FOREIGN KEY(ambiente_id) REFERENCES ambiente(id) ON DELETE CASCADE
      )
    ''');

    batch.execute('''
      CREATE TABLE cozinha (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        ambiente_id INTEGER NOT NULL,
        exigencia VARCHAR(50),
        loucas BOOLEAN,
        utensilios BOOLEAN,
        alimentos BOOLEAN,
        bebidas BOOLEAN,
        panos_de_prato BOOLEAN,
        itens_de_mesa BOOLEAN,
        panelas BOOLEAN,
        eletrodomesticos BOOLEAN,
        produtos_de_limpeza BOOLEAN,
        utensilios_de_limpeza BOOLEAN,
        outros BOOLEAN,
        FOREIGN KEY(ambiente_id) REFERENCES ambiente(id) ON DELETE CASCADE
      )
    ''');

    batch.execute('''
      CREATE TABLE quarto_criança (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        ambiente_id INTEGER NOT NULL,
        exigencia VARCHAR(50),
        roupas BOOLEAN,
        brinquedos BOOLEAN,
        calçados BOOLEAN,
        roupa_cama BOOLEAN,
        outros BOOLEAN,
        FOREIGN KEY(ambiente_id) REFERENCES ambiente(id) ON DELETE CASCADE
      )
    ''');

    batch.execute('''
      CREATE TABLE fotos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        ambiente_id INTEGER NOT NULL,
        caminho_foto VARCHAR(255) NOT NULL,
        descricao VARCHAR(255),
        data DATE NOT NULL,
        FOREIGN KEY(ambiente_id) REFERENCES ambiente(id) ON DELETE CASCADE
      )
    ''');

    batch.execute('''
      CREATE TABLE orçamento (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        visita_id INTEGER NOT NULL,
        total_preco DOUBLE,
        total_ambientes INTEGER,
        data DATE NOT NULL,
        FOREIGN KEY(visita_id) REFERENCES visita(id) ON DELETE CASCADE
      )
      ''');
      
    
  }

  @override
  void update(Batch batch) {


    
  }

  
}