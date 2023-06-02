// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hivedatamodel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveDataModelAdapter extends TypeAdapter<HiveDataModel> {
  @override
  final int typeId = 0;

  @override
  HiveDataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveDataModel()
      ..stockId = fields[0] as String
      ..stockName = fields[1] as String;
  }

  @override
  void write(BinaryWriter writer, HiveDataModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.stockId)
      ..writeByte(1)
      ..write(obj.stockName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveDataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
