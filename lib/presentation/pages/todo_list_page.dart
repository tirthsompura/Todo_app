import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/presentation/cubit/todo_state.dart';
import 'package:todo_app/presentation/cubit/todo_cubit.dart';
import 'package:todo_app/presentation/widgets/todo_item_widget.dart';

import 'todo_form_bottomsheet.dart';

class TodoListPage extends StatelessWidget {
  const TodoListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todos')),
      body: BlocBuilder<TodoCubit, TodoState>(
        builder: (context, state) {
          if (state.status == TodoStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == TodoStatus.error) {
            return Center(child: Text(state.message ?? 'Error'));
          }

          final todos = state.todos;
          if (todos.isEmpty) return const Center(child: Text('No todos yet.'));

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: todos.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final t = todos[index];
              return TodoItemWidget(todo: t);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (_) => const TodoFormBottomSheet(),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
