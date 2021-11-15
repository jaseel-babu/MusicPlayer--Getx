import 'package:hive/hive.dart';
part 'favorites.g.dart';

@HiveType(typeId: 3)
class Favoritesmodel extends HiveObject {
  @HiveField(0)
  late int index;
  Favoritesmodel({required this.index});
}
