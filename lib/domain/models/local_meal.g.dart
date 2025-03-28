// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_meal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocalMealAdapter extends TypeAdapter<LocalMeal> {
  @override
  final int typeId = 0;

  @override
  LocalMeal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocalMeal(
      id: fields[0] as String,
      name: fields[1] as String,
      calories: fields[2] as int,
      time: fields[3] as DateTime,
      photoPath: fields[4] as String?,
      notes: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, LocalMeal obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.calories)
      ..writeByte(3)
      ..write(obj.time)
      ..writeByte(4)
      ..write(obj.photoPath)
      ..writeByte(5)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalMealAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
