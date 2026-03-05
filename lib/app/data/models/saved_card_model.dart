import 'package:hive/hive.dart';
import '../../core/constants/hive_boxes.dart';

part 'saved_card_model.g.dart';

@HiveType(typeId: HiveBoxes.savedCardTypeId)
class SavedCardModel extends HiveObject {
  @HiveField(0)
  final String cardNumber;

  @HiveField(1)
  final String cardHolder;

  @HiveField(2)
  final String validUntil;

  @HiveField(3)
  final String paymentMethod;

  SavedCardModel({
    required this.cardNumber,
    required this.cardHolder,
    required this.validUntil,
    required this.paymentMethod,
  });
}
