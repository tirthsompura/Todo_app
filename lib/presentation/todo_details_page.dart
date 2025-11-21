import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/domain/todo.dart';
import 'package:todo_app/presentation/cubit/todo_cubit.dart';
import 'package:todo_app/presentation/cubit/todo_state.dart';
import 'package:todo_app/presentation/pages/todo_form_bottomsheet.dart';

class TodoDetailsPage extends StatelessWidget {
  final Todo todo;
  const TodoDetailsPage({super.key, required this.todo});

  String format(int sec) {
    final d = Duration(seconds: sec);
    return "${d.inHours}:${d.inMinutes % 60}:${d.inSeconds % 60}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(todo.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (_) => TodoFormBottomSheet(todo: todo),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<TodoCubit, TodoState>(
        builder: (context, state) {
          final t = state.todos.firstWhere((x) => x.id == todo.id);

          final now = DateTime.now();
          final add = t.isRunning && t.lastStartAt != null
              ? now.difference(t.lastStartAt!).inSeconds
              : 0;

          final display = t.seconds + add;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.description, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 20),

                Text("Status: ${statusText(t)}"),
                const SizedBox(height: 20),

                Text("Time: ${format(display)}", style: const TextStyle(fontSize: 22)),
                const SizedBox(height: 20),

                Row(
                  children: [
                    IconButton(
                      icon: Icon(t.isRunning ? Icons.pause : Icons.play_arrow),
                      onPressed: () {
                        context.read<TodoCubit>().toggleStartPause(t.id);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.stop),
                      onPressed: () {
                        context.read<TodoCubit>().stopTimer(t);
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String statusText(Todo t) {
    if (t.isDone) return "Done";
    if (t.isRunning) return "In-Progress";
    if (t.seconds > 0) return "Paused";
    return "TODO";
  }
}
