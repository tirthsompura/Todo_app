import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/domain/todo.dart';
import 'package:todo_app/presentation/todo_details_page.dart';
import '../cubit/todo_cubit.dart';

class TodoItemWidget extends StatelessWidget {
  final Todo todo;

  const TodoItemWidget({super.key, required this.todo});

  String _formatDuration(int seconds) {
    final d = Duration(seconds: seconds);
    final hh = d.inHours.toString().padLeft(2, '0');
    final mm = (d.inMinutes % 60).toString().padLeft(2, '0');
    final ss = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$hh:$mm:$ss';
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final runningAdd = todo.isRunning && todo.lastStartAt != null
        ? now.difference(todo.lastStartAt!).inSeconds
        : 0;
    final displaySec = todo.seconds + runningAdd;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => TodoDetailsPage(todo: todo)),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            todo.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _statusChip(todo),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      todo.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Timer: ${_formatDuration(displaySec)}'),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                todo.isRunning
                                    ? Icons.pause_circle
                                    : Icons.play_circle,
                              ),
                              onPressed: () => context
                                  .read<TodoCubit>()
                                  .toggleStartPause(todo.id),
                            ),
                            IconButton(
                              icon: const Icon(Icons.check_circle),
                              onPressed: () =>
                                  context.read<TodoCubit>().markDone(todo.id),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _confirmDelete(context),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusChip(Todo t) {
    if (t.isDone) return const Chip(label: Text('Done'));
    if (t.isRunning) return const Chip(label: Text('In-Progress'));
    if (!t.isRunning && t.seconds > 0) {
      return const Chip(label: Text('Paused'));
    }
    return const Chip(label: Text('TODO'));
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete?'),
        content: const Text('Are you sure you want to delete this todo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<TodoCubit>().deleteTodo(todo.id);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
