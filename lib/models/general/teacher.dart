class Teacher {
  final int id;
  final String name;
  final String avatar;
  final String whatsapp;
  final String telegram;
  final String teacherProfileLink;

  Teacher({
    required this.id,
    required this.name,
    required this.avatar,
    required this.whatsapp,
    required this.telegram,
    required this.teacherProfileLink,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) => Teacher(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        avatar: json['avatar'] ?? '',
        whatsapp: json['whatsapp'] ?? '',
        telegram: json['telegram'] ?? '',
        teacherProfileLink: json['teacher_profile_link'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'image': avatar,
        'whatsapp': whatsapp,
        'telegram': telegram,
        'teacher_profile_link': teacherProfileLink,
      };
}
