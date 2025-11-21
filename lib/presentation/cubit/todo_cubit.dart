import 'package:todo_app/data/repositories/todo_repository.dart';
import 'package:todo_app/presentation/cubit/todo_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import '../../domain/todo.dart';

class TodoCubit extends Cubit<TodoState> {
  final TodoRepository repo;

  TodoCubit(this.repo) : super(const TodoState.initial());

  // LOAD TODOS
  Future<void> loadTodos() async {
    emit(state.copyWith(status: TodoStatus.loading));

    try {
      final todos = await repo.getAllTodos();
      emit(state.copyWith(status: TodoStatus.loaded, todos: todos));
    } catch (e) {
      emit(state.copyWith(status: TodoStatus.error, message: e.toString()));
    }
  }

  // ADD
  Future<void> addTodo(String title, String desc, int initialSec) async {
    final todo = Todo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: desc,
      seconds: initialSec,
      isRunning: false,
      lastStartAt: null,
      isDone: false,
    );

    await repo.addTodo(todo);
    await loadTodos();
  }

  Future<void> editTodo(String id, String title, String desc, int initialSec) async {
    final current = state.todos.firstWhere((t) => t.id == id);
    final updated = current.copyWith(
      title: title,
      description: desc,
      elapsedSeconds: initialSec,
    );

    await repo.updateTodo(updated);
    await loadTodos();
  }

  // DELETE
  Future<void> deleteTodo(String id) async {
    await repo.deleteTodo(id);
    await loadTodos();
  }

  // UPDATE
  Future<void> toggleDone(Todo todo) async {
    final updated = todo.copyWith(isDone: !todo.isDone);
    await repo.updateTodo(updated);
    await loadTodos();
  }

  // START TIMER
  Future<void> startTimer(Todo todo) async {
    if (todo.isRunning) return;

    final updated = todo.copyWith(isRunning: true, lastStartAt: DateTime.now());

    await repo.updateTodo(updated);
    await loadTodos();
  }

  // STOP TIMER
  Future<void> stopTimer(Todo todo) async {
    if (!todo.isRunning) return;

    final now = DateTime.now();
    final diff = now.difference(todo.lastStartAt!).inSeconds;

    final updated = todo.copyWith(
      isRunning: false,
      lastStartAt: null,
      elapsedSeconds: todo.seconds + diff,
    );

    await repo.updateTodo(updated);
    await loadTodos();
  }

  Future<void> toggleStartPause(String id) async {
    final current = state.todos.firstWhere((t) => t.id == id);

    if (!current.isRunning) {
      // Start timer
      final updated = current.copyWith(
        isRunning: true,
        lastStartAt: DateTime.now(),
      );

      await repo.updateTodo(updated);
    } else {
      // Pause
      final now = DateTime.now();
      final diff = now.difference(current.lastStartAt!).inSeconds;

      final updated = current.copyWith(
        isRunning: false,
        lastStartAt: null,
        elapsedSeconds: current.seconds + diff,
      );

      await repo.updateTodo(updated);
    }

    await loadTodos();
  }

  // Mark todo as completed
  Future<void> markDone(String id) async {
    final current = state.todos.firstWhere((t) => t.id == id);

    final updated = current.copyWith(isDone: true, isRunning: false);

    await repo.updateTodo(updated);
    await loadTodos();
  }
}
