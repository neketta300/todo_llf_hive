import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:llf_todo_app/domain/entity/group.dart';
import 'package:llf_todo_app/domain/entity/task.dart';

class TaskFormWidgetModel {
  int groupKey;
  String taskText = '';

  TaskFormWidgetModel({required this.groupKey});

  void saveTask(BuildContext context) async {
    if (taskText.isEmpty) return;

    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(TaskAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(GroupAdapter());
    }

    final taskBox = await Hive.openBox<Task>('tasks_box');
    final task = Task(isDone: false, text: taskText);
    await taskBox.add(task);

    final groupBox = await Hive.openBox<Group>('groups_box');
    final group = groupBox.get(groupKey);

    group?.addTask(taskBox, task);

    Navigator.of(context).pop();
  }
}

class TaskFormWidgetModelProvider extends InheritedWidget {
  final TaskFormWidgetModel model;
  const TaskFormWidgetModelProvider({
    required this.model,
    Key? key,
    required Widget child,
  }) : super(key: key, child: child);

  static TaskFormWidgetModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<TaskFormWidgetModelProvider>();
  }

  static TaskFormWidgetModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<TaskFormWidgetModelProvider>()
        ?.widget;
    return widget is TaskFormWidgetModelProvider ? widget : null;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}
