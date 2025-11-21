import 'package:hive/hive.dart';
import 'package:todo_app/data/model/todo_model.dart';
import 'todo_local_datasource.dart';

class TodoLocalDataSourceImpl implements TodoLocalDataSource {
  final Box<TodoModel> box;

  TodoLocalDataSourceImpl(this.box);

  @override
  Future<void> addTodo(TodoModel model) async {
    await box.put(model.id, model);
  }

  @override
  Future<void> deleteTodo(String id) async {
    await box.delete(id);
  }

  @override
  Future<List<TodoModel>> getAllTodos() async {
    return box.values.toList();
  }

  @override
  Future<void> updateTodo(TodoModel model) async {
    await box.put(model.id, model);
  }
}
