// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrderModelAdapter extends TypeAdapter<OrderModel> {
  @override
  final int typeId = 0;

  @override
  OrderModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrderModel(
      id: fields[0] as String,
      gameId: fields[1] as String,
      gameTitle: fields[2] as String,
      totalPrice: fields[3] as double,
      paymentMethod: fields[4] as String,
      cardNumber: fields[5] as String,
      cardHolder: fields[6] as String,
      validUntil: fields[7] as String,
      promoCode: fields[8] as String,
      saveCard: fields[9] as bool,
      createdAt: fields[10] as DateTime,
      discount: fields[11] as double,
    );
  }

  @override
  void write(BinaryWriter writer, OrderModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.gameId)
      ..writeByte(2)
      ..write(obj.gameTitle)
      ..writeByte(3)
      ..write(obj.totalPrice)
      ..writeByte(4)
      ..write(obj.paymentMethod)
      ..writeByte(5)
      ..write(obj.cardNumber)
      ..writeByte(6)
      ..write(obj.cardHolder)
      ..writeByte(7)
      ..write(obj.validUntil)
      ..writeByte(8)
      ..write(obj.promoCode)
      ..writeByte(9)
      ..write(obj.saveCard)
      ..writeByte(10)
      ..write(obj.createdAt)
      ..writeByte(11)
      ..write(obj.discount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
