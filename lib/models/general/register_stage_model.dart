class RegisterStage {
  final int id;
  final String name;
  final List<RegisterLevel> levels;

  RegisterStage({
    required this.id,
    required this.name,
    required this.levels,
  });

  factory RegisterStage.fromJson(Map<String, dynamic> json) {
    return RegisterStage(
      id: json['id'],
      name: json['name'] ?? json['st_name'] ?? '',
      levels: json['levels'] != null
          ? List<RegisterLevel>.from(
              (json['levels'] as List).map((item) => RegisterLevel.fromJson(item)))
          : [],
    );
  }
}

class RegisterLevel {
  final int id;
  final String name;

  RegisterLevel({
    required this.id,
    required this.name,
  });

  factory RegisterLevel.fromJson(Map<String, dynamic> json) {
    return RegisterLevel(
      id: json['id'],
      name: json['name'] ?? json['st_name'] ?? '',
    );
  }
}
