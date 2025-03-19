import 'package:llf_todo_app/ui/widgets/tasks/tasks_widget_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TasksWidgetConfiguration {
  final int groupKey;
  final String groupTitleName;

  TasksWidgetConfiguration(
      {required this.groupKey, required this.groupTitleName});
}

class TasksWidget extends StatefulWidget {
  final TasksWidgetConfiguration configuration;
  const TasksWidget({
    super.key,
    required this.configuration,
  });

  @override
  _TasksWidgetState createState() => _TasksWidgetState();
}

class _TasksWidgetState extends State<TasksWidget> {
  late final TasksWidgetModel _model;

  @override
  void initState() {
    super.initState();
    _model = TasksWidgetModel(configuration: widget.configuration);
  }

  @override
  Widget build(BuildContext context) {
    return TasksWidgetModelProvider(
      model: _model,
      child: const TasksWidgetBody(),
    );
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }
}

class TasksWidgetBody extends StatelessWidget {
  const TasksWidgetBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = TasksWidgetModelProvider.watch(context)?.model;
    final title = model?.configuration.groupTitleName ?? 'Задачи';
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: const _TaskListWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => model?.showForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _TaskListWidget extends StatelessWidget {
  const _TaskListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final groupsCount =
        TasksWidgetModelProvider.watch(context)?.model.tasks.length ?? 0;
    return ListView.separated(
      itemCount: groupsCount,
      itemBuilder: (BuildContext context, int index) {
        return _TaskListRowWidget(taskListIndex: index);
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(height: 1);
      },
    );
  }
}

class _TaskListRowWidget extends StatelessWidget {
  final int taskListIndex;
  const _TaskListRowWidget({
    Key? key,
    required this.taskListIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = TasksWidgetModelProvider.read(context)!.model;
    final task = model.tasks[taskListIndex];

    final icon = task.isDone ? Icons.done : null;
    final style = task.isDone
        ? const TextStyle(
            color: Colors.black,
            decoration: TextDecoration.lineThrough,
          )
        : TextStyle(color: Colors.black);

    return Slidable(
      endActionPane: ActionPane(
        motion: BehindMotion(),
        children: [
          SlidableAction(
            onPressed: (BuildContext context) =>
                model.deleteTask(taskListIndex),
            backgroundColor: Color.fromARGB(255, 223, 16, 16),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Удалить',
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          task.text,
          style: style,
        ),
        trailing: Icon(icon),
        onTap: () => model.doneToggle(taskListIndex),
      ),
    );
  }
}
