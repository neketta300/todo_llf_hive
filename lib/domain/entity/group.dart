import 'package:hive/hive.dart';
part 'group.g.dart';

@HiveType(typeId: 1)
class Group {
  @HiveField(0)
  String name;

  @HiveField(1)
  HiveList? task;

  Group({
    required this.name,
  });
}
