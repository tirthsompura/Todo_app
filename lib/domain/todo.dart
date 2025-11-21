import 'package:equatable/equatable.dart';


class Todo extends Equatable {
  final String id;
  final String title;
  final String description;
  final int seconds;
  final bool isRunning;
  final DateTime? lastStartAt;
  final bool isDone;


  const Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.seconds,
    required this.isRunning,
    required this.lastStartAt,
    required this.isDone,
  });


  @override
  List<Object?> get props => [id, title, description, seconds, isRunning, lastStartAt, isDone];


  Todo copyWith({
    String? id,
    String? title,
    String? description,
    int? elapsedSeconds,
    bool? isRunning,
    DateTime? lastStartAt,
    bool? isDone,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      seconds: elapsedSeconds ?? this.seconds,
      isRunning: isRunning ?? this.isRunning,
      lastStartAt: lastStartAt ?? this.lastStartAt,
      isDone: isDone ?? this.isDone,
    );
  }
}