class EnvironmentObject {
  final String name;
  final String difficulty;
  final String? observation;

  EnvironmentObject({
    required this.name,
    required this.difficulty,
    this.observation,
  });
}
