import 'package:hive/hive.dart';
import 'package:llf_todo_app/domain/entity/group.dart';
import 'package:llf_todo_app/domain/entity/task.dart';

class BoxManager {
  static final BoxManager instance = BoxManager._(); // singleton
  final Map<String, int> _boxConter = <String, int>{};
  BoxManager._(); // private constructor

  Future<Box<Group>> openGroupBox() async {
    return _openBox('groups_box', 1, GroupAdapter());
  }

  Future<Box<Task>> openTaskBox(int groupKey) async {
    return _openBox('tasks_box_$groupKey', 2, TaskAdapter());
  }

  Future<void> closeBox<T>(Box<T> box) async {
    if (!box.isOpen) {
      _boxConter.remove(box.name);
      return;
    }

    final count = _boxConter[box.name] ?? 1;
    _boxConter[box.name] = count - 1;
    if (count > 0) return;

    _boxConter.remove(box.name);
    await box.compact(); // сжатие бокса
    await box.close();
  }

  String makeTaskBoxName(int groupKey) => 'tasks_box_$groupKey';

  Future<Box<T>> _openBox<T>(
    String name,
    int typeId,
    TypeAdapter<T> adapter,
  ) async {
    if (Hive.isBoxOpen(name)) {
      final count = _boxConter[name] ?? 1;
      _boxConter[name] = count + 1;
      return Hive.openBox(name);
    }
    _boxConter[name] = 1;
    if (!Hive.isBoxOpen(name)) {
      Hive.registerAdapter(adapter);
    }
    return Hive.openBox<T>(name);
  }
}
