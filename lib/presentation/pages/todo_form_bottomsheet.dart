import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/domain/todo.dart';
import 'package:todo_app/presentation/cubit/todo_cubit.dart';

class TodoFormBottomSheet extends StatefulWidget {
  final Todo? todo;
  const TodoFormBottomSheet({super.key,this.todo});

  @override
  State<TodoFormBottomSheet> createState() => _TodoFormBottomSheetState();
}

class _TodoFormBottomSheetState extends State<TodoFormBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _minCtrl = TextEditingController();
  final _secCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.todo != null) {
      _titleCtrl.text = widget.todo!.title;
      _descCtrl.text = widget.todo!.description;

      final d = Duration(seconds: widget.todo!.seconds);
      _minCtrl.text = d.inMinutes.toString();
      _secCtrl.text = (d.inSeconds % 60).toString();
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descCtrl,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _minCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Min (0-5)"),
                      validator: (v) {
                        final m = int.tryParse(v ?? "0") ?? 0;
                        if (m < 0 || m > 5) return "Max 5 min";
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _secCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Sec (0-59)"),
                      validator: (v) {
                        final s = int.tryParse(v ?? "0") ?? 0;
                        if (s < 0 || s > 59) return "0-59 only";
                        return null;
                      },
                    ),
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // BUTTON CANCEL
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  // BUTTON ADD UPDATE
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final min = int.tryParse(_minCtrl.text) ?? 0;
                        final sec = int.tryParse(_secCtrl.text) ?? 0;
                        final totalSec = (min * 60) + sec;

                        if (widget.todo == null) {
                          // ADD NEW TODO
                          context.read<TodoCubit>().addTodo(
                            _titleCtrl.text.trim(),
                            _descCtrl.text.trim(),
                            totalSec,   // ADD THIS
                          );
                        } else {
                          // EDIT TODO
                          context.read<TodoCubit>().editTodo(
                            widget.todo!.id,
                            _titleCtrl.text.trim(),
                            _descCtrl.text.trim(),
                            totalSec,
                          );
                        }

                        Navigator.pop(context);
                      }
                    },
                    child: Text(widget.todo == null ? 'Add' : 'Update'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
