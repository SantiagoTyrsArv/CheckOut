import '../models/order_model.dart';
import '../models/saved_card_model.dart';
import '../providers/hive_provider.dart';

/// Repository Pattern: abstrae la fuente de datos del dominio.
abstract class IOrderRepository {
  Future<void> placeOrder(OrderModel order);
  List<OrderModel> fetchOrders();
  Future<void> removeOrder(String id);
  Future<void> saveCard(SavedCardModel card);
  SavedCardModel? getSavedCard();
}

class OrderRepository implements IOrderRepository {
  final HiveProvider _provider;

  OrderRepository(this._provider);

  @override
  Future<void> placeOrder(OrderModel order) => _provider.saveOrder(order);

  @override
  List<OrderModel> fetchOrders() => _provider.getAllOrders();

  @override
  Future<void> removeOrder(String id) => _provider.deleteOrder(id);

  @override
  Future<void> saveCard(SavedCardModel card) => _provider.saveCard(card);

  @override
  SavedCardModel? getSavedCard() => _provider.getSavedCard();
}
