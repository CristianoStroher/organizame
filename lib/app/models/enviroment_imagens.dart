import 'dart:io';

class EnviromentImagens {
  final String id;
  final String filePath;
  final DateTime creationDate;
  final DateTime dateTime;
  final String? description;
  
  EnviromentImagens({
    required this.id,
    required this.filePath,
    required this.creationDate,
    required this.dateTime,
    this.description,
  });

  // Construtor para criar a partir de um Map (JSON)
  factory EnviromentImagens.fromJson(Map<String, dynamic> json) {
    return EnviromentImagens(
      id: json['id'] as String,
      filePath: json['filePath'] as String,
      creationDate: DateTime.parse(json['creationDate'] as String),
      dateTime: DateTime.parse(json['dateTime'] as String),
      description: json['description'] as String?,
    );
  }

  // Método para converter para Map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'filePath': filePath,
      'creationDate': creationDate.toIso8601String(),
      'dateTime': dateTime.toIso8601String(),
      'description': description,
    };
  }

  // Método para criar uma cópia do objeto com algumas alterações
  EnviromentImagens copyWith({
    String? id,
    String? filePath,
    DateTime? creationDate,
    DateTime? dateTime,
    String? description,
  }) {
    return EnviromentImagens(
      id: id ?? this.id,
      filePath: filePath ?? this.filePath,
      creationDate: creationDate ?? this.creationDate,
      dateTime: dateTime ?? this.dateTime,
      description: description ?? this.description,
    );
  }

  // Sobrescrita do método toString para depuração
  @override
  String toString() {
    return 'EnviromentImagens(id: $id, filePath: $filePath, creationDate: $creationDate, dateTime: $dateTime, description: $description)';
  }

  // Sobrescrita do operador == para comparações
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is EnviromentImagens &&
      other.id == id &&
      other.filePath == filePath &&
      other.creationDate == creationDate &&
      other.dateTime == dateTime &&
      other.description == description;
  }

  // Sobrescrita do hashCode para uso em coleções
  @override
  int get hashCode {
    return id.hashCode ^
      filePath.hashCode ^
      creationDate.hashCode ^
      dateTime.hashCode ^
      description.hashCode;
  }

  // Método para criar uma instância com valores padrão
  factory EnviromentImagens.create({
    required String filePath,
    String? description,
  }) {
    final now = DateTime.now();
    return EnviromentImagens(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      filePath: filePath,
      creationDate: now,
      dateTime: now,
      description: description,
    );
  }

  // Método para verificar se a imagem existe
  Future<bool> exists() async {
    final file = File(filePath);
    return await file.exists();
  }

  // Método para deletar a imagem
  Future<void> delete() async {
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
  }
}