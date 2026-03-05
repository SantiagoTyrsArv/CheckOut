// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_card_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SavedCardModelAdapter extends TypeAdapter<SavedCardModel> {
  @override
  final int typeId = 1;

  @override
  SavedCardModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SavedCardModel(
      cardNumber: fields[0] as String,
      cardHolder: fields[1] as String,
      validUntil: fields[2] as String,
      paymentMethod: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SavedCardModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.cardNumber)
      ..writeByte(1)
      ..write(obj.cardHolder)
      ..writeByte(2)
      ..write(obj.validUntil)
      ..writeByte(3)
      ..write(obj.paymentMethod);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavedCardModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
