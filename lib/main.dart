import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import 'package:llf_todo_app/widgets/group_form/group_form_widget.dart';
import 'package:llf_todo_app/widgets/groups/groups_widget.dart';
import 'package:llf_todo_app/widgets/task_form/task_form_widget.dart';
import 'package:llf_todo_app/widgets/tasks/tasks_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      routes: {
        '/groups': (context) => const GroupsWidget(),
        '/groups/form': (context) => const GroupFormWidget(),
        '/groups/form/tasks': (context) => const TasksWidget(),
        '/groups/form/tasks/form': (context) => const TaskFormWidget(),
      },
      initialRoute: '/groups',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
