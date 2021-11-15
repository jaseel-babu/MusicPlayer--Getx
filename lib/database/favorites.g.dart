// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorites.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavoritesmodelAdapter extends TypeAdapter<Favoritesmodel> {
  @override
  final int typeId = 3;

  @override
  Favoritesmodel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Favoritesmodel(
      index: fields[0] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Favoritesmodel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.index);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoritesmodelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
