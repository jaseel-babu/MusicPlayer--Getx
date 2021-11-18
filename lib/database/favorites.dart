import 'package:hive/hive.dart';
part 'favorites.g.dart';

@HiveType(typeId: 4)
class favoritesmodel extends HiveObject {
  @HiveField(0)
  late dynamic favorites;

  favoritesmodel({required this.favorites});
}
