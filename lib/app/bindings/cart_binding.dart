import 'package:get/get.dart';
import '../modules/cart/cart_controller.dart';

class CartBinding extends Bindings {
  @override
  void dependencies() {
    // permanent: true → el carrito persiste en toda la sesión
    Get.put<CartController>(CartController(), permanent: true);
  }
}
