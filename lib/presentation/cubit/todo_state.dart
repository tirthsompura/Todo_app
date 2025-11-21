import 'package:equatable/equatable.dart';
import '../../domain/todo.dart';

enum TodoStatus { initial, loading, loaded, error }

class TodoState extends Equatable {
  final TodoStatus status;
  final List<Todo> todos;
  final String? message;

  const TodoState({
    required this.status,
    required this.todos,
    this.message,
  });

  const TodoState.initial()
      : status = TodoStatus.initial,
        todos = const [],
        message = null;

  TodoState copyWith({
    TodoStatus? status,
    List<Todo>? todos,
    String? message,
  }) {
    return TodoState(
      status: status ?? this.status,
      todos: todos ?? this.todos,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, todos, message];
}
