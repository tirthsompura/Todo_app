import 'package:todo_app/data/model/todo_model.dart';

abstract class TodoLocalDataSource {
  Future<List<TodoModel>> getAllTodos();
  Future<void> addTodo(TodoModel todo);
  Future<void> updateTodo(TodoModel todo);
  Future<void> deleteTodo(String id);
}


