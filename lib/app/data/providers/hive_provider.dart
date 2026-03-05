import 'package:hive_flutter/hive_flutter.dart';
import '../models/order_model.dart';
import '../models/saved_card_model.dart';
import '../../core/constants/hive_boxes.dart';

/// Capa de acceso directo a Hive (DAO).
/// Solo conoce Hive, sin lógica de negocio.
class HiveProvider {
  // ── Orders
  Box<OrderModel> get _ordersBox => Hive.box<OrderModel>(HiveBoxes.orders);

  Future<void> saveOrder(OrderModel order) async {
    await _ordersBox.put(order.id, order);
  }

  List<OrderModel> getAllOrders() => _ordersBox.values.toList();

  OrderModel? getOrderById(String id) => _ordersBox.get(id);

  Future<void> deleteOrder(String id) async => await _ordersBox.delete(id);

  Future<void> clearAllOrders() async => await _ordersBox.clear();

  // ── Saved Cards
  Box<SavedCardModel> get _cardsBox =>
      Hive.box<SavedCardModel>(HiveBoxes.savedCards);

  Future<void> saveCard(SavedCardModel card) async {
    await _cardsBox.put('default_card', card);
  }

  SavedCardModel? getSavedCard() => _cardsBox.get('default_card');

  Future<void> deleteCard() async => await _cardsBox.delete('default_card');
}
