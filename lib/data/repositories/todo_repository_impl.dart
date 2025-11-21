import 'package:todo_app/data/model/todo_model.dart';
import 'package:todo_app/domain/todo.dart';
import '../datasources/todo_local_datasource.dart';
import 'todo_repository.dart';


class TodoRepositoryImpl implements TodoRepository {
  final TodoLocalDataSource local;
  TodoRepositoryImpl(this.local);

  @override
  Future<void> addTodo(Todo todo) async {
    final model = TodoModel.fromEntity(todo);
    await local.addTodo(model);
  }

  @override
  Future<void> deleteTodo(String id) async {
    await local.deleteTodo(id);
  }

  @override
  Future<List<Todo>> getAllTodos() async {
    final models = await local.getAllTodos();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> updateTodo(Todo todo) async {
    final model = TodoModel.fromEntity(todo);
    await local.updateTodo(model);
  }
}