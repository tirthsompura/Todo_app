import 'package:flutter/material.dart';
import 'package:todo_app/data/datasources/todo_local_data_source_impl.dart';
import 'package:todo_app/data/model/todo_model.dart';
import 'package:todo_app/data/repositories/todo_repository.dart';
import 'package:todo_app/data/repositories/todo_repository_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/presentation/pages/todo_list_page.dart';

import 'presentation/cubit/todo_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TodoModelAdapter());

  final box = await Hive.openBox<TodoModel>('todos');
  final local = TodoLocalDataSourceImpl(box);
  final repo = TodoRepositoryImpl(local);
  runApp(MyApp(repo));
}

class MyApp extends StatelessWidget {
  final TodoRepository repo;

  const MyApp(this.repo, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TodoCubit(repo)..loadTodos(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: TodoListPage(),
      ),
    );
  }
}

