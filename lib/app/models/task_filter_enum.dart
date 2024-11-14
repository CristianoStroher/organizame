enum TaskFilterEnum {
  today,
  tomorrow,
  week,
  old,
}

extension TaskFilterEnumExtension on TaskFilterEnum {
  String get description {
    switch (this) {
      case TaskFilterEnum.today:
        return 'DE HOJE';
      case TaskFilterEnum.tomorrow:
        return 'DE AMANHÃ';
      case TaskFilterEnum.week:
        return 'DA SEMANA';
      case TaskFilterEnum.old:
        return 'ANTIGAS';
      default:
        return '';
    }
  }
}