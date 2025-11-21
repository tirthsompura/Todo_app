import 'package:hive/hive.dart';
import 'package:todo_app/domain/todo.dart';
import 'package:uuid/uuid.dart';
part 'todo_model.g.dart';

@HiveType(typeId: 0)
class TodoModel extends HiveObject {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final int elapsedSeconds;

  @HiveField(4)
  final bool isRunning;

  @HiveField(5)
  final DateTime? lastStartAt;

  @HiveField(6)
  final bool isDone;

  TodoModel({
    String? id,
    required this.title,
    required this.description,
    this.elapsedSeconds = 0,
    this.isRunning = false,
    this.lastStartAt,
    this.isDone = false,
  }) : id = id ?? const Uuid().v4();

  factory TodoModel.fromEntity(Todo todo) {
    return TodoModel(
      id: todo.id,
      title: todo.title,
      description: todo.description,
      elapsedSeconds: todo.seconds,
      isRunning: todo.isRunning,
      lastStartAt: todo.lastStartAt,
      isDone: todo.isDone,
    );
  }

  Todo toEntity() {
    return Todo(
      id: id ?? '',
      title: title,
      description: description,
      seconds: elapsedSeconds,
      isRunning: isRunning,
      lastStartAt: lastStartAt,
      isDone: isDone,
    );
  }
}

