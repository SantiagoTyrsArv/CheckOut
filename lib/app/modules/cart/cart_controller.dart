import 'package:get/get.dart';
import '../../data/models/cart_item_model.dart';
import '../../data/models/game_model.dart';
import '../../routes/app_routes.dart';

class CartController extends GetxController {
  final RxList<CartItemModel> items = <CartItemModel>[].obs;

  int get totalItems => items.fold(0, (sum, i) => sum + i.quantity);

  double get totalPrice =>
      items.fold(0.0, (sum, i) => sum + i.subtotal);

  bool isInCart(String gameId) =>
      items.any((i) => i.gameId == gameId);

  void addToCart(GameModel game) {
    final index = items.indexWhere((i) => i.gameId == game.id);
    if (index >= 0) {
      items[index].quantity++;
      items.refresh(); // notifica el cambio de quantity
    } else {
      items.add(CartItemModel(
        gameId: game.id,
        title: game.title,
        price: game.price,
        imageUrl: game.imageUrl,
      ));
    }
    Get.snackbar(
      '🛒 Agregado',
      '${game.title} fue añadido al carrito',
      duration: const Duration(seconds: 2),
    );
  }

  void increaseQuantity(String gameId) {
    final index = items.indexWhere((i) => i.gameId == gameId);
    if (index >= 0) {
      items[index].quantity++;
      items.refresh();
    }
  }

  void decreaseQuantity(String gameId) {
    final index = items.indexWhere((i) => i.gameId == gameId);
    if (index >= 0) {
      if (items[index].quantity <= 1) {
        items.removeAt(index);
      } else {
        items[index].quantity--;
        items.refresh();
      }
    }
  }

  void removeItem(String gameId) {
    items.removeWhere((i) => i.gameId == gameId);
  }

  void clearCart() => items.clear();

  void goToCheckout() {
    if (items.isEmpty) {
      Get.snackbar('Carrito vacío', 'Agrega productos antes de continuar');
      return;
    }
    Get.toNamed(AppRoutes.paymentData, arguments: {'cartItems': items, 'total': totalPrice});
  }
}
