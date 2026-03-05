import 'package:hive/hive.dart';
import '../../core/constants/hive_boxes.dart';

part 'order_model.g.dart';

@HiveType(typeId: HiveBoxes.orderTypeId)
class OrderModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String gameId;

  @HiveField(2)
  final String gameTitle;

  @HiveField(3)
  final double totalPrice;

  @HiveField(4)
  final String paymentMethod; // 'paypal' | 'credit' | 'wallet'

  @HiveField(5)
  final String cardNumber; // Solo últimos 4 dígitos

  @HiveField(6)
  final String cardHolder;

  @HiveField(7)
  final String validUntil;

  @HiveField(8)
  final String promoCode;

  @HiveField(9)
  final bool saveCard;

  @HiveField(10)
  final DateTime createdAt;

  @HiveField(11)
  final double discount;

  OrderModel({
    required this.id,
    required this.gameId,
    required this.gameTitle,
    required this.totalPrice,
    required this.paymentMethod,
    required this.cardNumber,
    required this.cardHolder,
    required this.validUntil,
    required this.promoCode,
    required this.saveCard,
    required this.createdAt,
    this.discount = 0.0,
  });

  OrderModel copyWith({
    String? promoCode,
    double? discount,
    String? paymentMethod,
  }) {
    return OrderModel(
      id: id,
      gameId: gameId,
      gameTitle: gameTitle,
      totalPrice: totalPrice,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      cardNumber: cardNumber,
      cardHolder: cardHolder,
      validUntil: validUntil,
      promoCode: promoCode ?? this.promoCode,
      saveCard: saveCard,
      createdAt: createdAt,
      discount: discount ?? this.discount,
    );
  }
}
