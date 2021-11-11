import 'package:hive/hive.dart';
part 'datamodel.g.dart';

@HiveType(typeId: 0)
class DataModel extends HiveObject {
  @HiveField(0)
  late List? songdata;
}
