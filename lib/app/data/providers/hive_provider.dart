import 'package:hive_flutter/hive_flutter.dart';
import '../models/order_model.dart';
import '../../core/constants/hive_boxes.dart';

/// Capa de acceso directo a Hive (DAO).
/// Solo conoce Hive, no lógica de negocio.
class HiveProvider {
  Box<OrderModel> get _box => Hive.box<OrderModel>(HiveBoxes.orders);

  Future<void> saveOrder(OrderModel order) async {
    await _box.put(order.id, order);
  }

  List<OrderModel> getAllOrders() {
    return _box.values.toList();
  }

  OrderModel? getOrderById(String id) {
    return _box.get(id);
  }

  Future<void> deleteOrder(String id) async {
    await _box.delete(id);
  }

  Future<void> clearAll() async {
    await _box.clear();
  }
}
