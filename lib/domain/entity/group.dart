import 'package:hive/hive.dart';

part 'group.g.dart';

@HiveType(typeId: 1)
class Group extends HiveObject {
  //used HiveField key 1
  @HiveField(0)
  String name;


  Group({
    required this.name,
  });
}
