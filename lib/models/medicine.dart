import 'package:uuid/uuid.dart';

class Medicine {
  final String id;
  final String name;
  final int count;
  final String type;
  final String imagePath;
  final String userId;

  Medicine({
    required this.id,
    required this.name,
    required this.count,
    required this.type,
    required this.imagePath,
    required this.userId,
  });

  Medicine copyWith({
    String? id,
    String? name,
    int? count,
    String? type,
    String? imagePath,
    String? userId,
  }) {
    return Medicine(
      id: id ?? this.id,
      name: name ?? this.name,
      count: count ?? this.count,
      type: type ?? this.type,
      imagePath: imagePath ?? this.imagePath,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'count': count,
      'type': type,
      'imagePath': imagePath,
      'userId': userId,
    };
  }

  factory Medicine.fromMap(Map<String, dynamic> map) {
    return Medicine(
      id: map['id'] ?? Uuid().v4(),
      name: map['name'] ?? '',
      count: map['count'] ?? 0,
      type: map['type'] ?? '',
      imagePath: map['imagePath'] ?? '',
      userId: map['userId'] ?? '',
    );
  }
}
