class TaskModel {
  final int id;
  final String name;
  final String description;
  final bool isHighPriority;
  final bool isCompleted;

  TaskModel({
    required this.id,
    required this.name,
    required this.description,
    this.isHighPriority = false,
    this.isCompleted = false,
  });

  factory TaskModel.fromMap(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      isHighPriority: json['isHighPriority'] as bool? ?? false,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'isHighPriority': isHighPriority,
      'isCompleted': isCompleted,
    };
  }
}
