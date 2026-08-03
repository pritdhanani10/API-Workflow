class Student {
  final int? id;
  final String name;
  final String email;
  final String course;
  final DateTime? createdAt;

  Student({
    this.id,
    required this.name,
    required this.email,
    required this.course,
    this.createdAt,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] as int?,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      course: json['course'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'email': email,
      'course': course,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
    };
  }
}
