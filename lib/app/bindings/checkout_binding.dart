import 'package:get/get.dart';
import '../data/providers/hive_provider.dart';
import '../data/repositories/order_repository.dart';
import '../modules/checkout/checkout_controller.dart';

class CheckoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HiveProvider>(() => HiveProvider());
    Get.lazyPut<IOrderRepository>(
          () => OrderRepository(Get.find<HiveProvider>()),
    );
    Get.lazyPut<CheckoutController>(
          () => CheckoutController(Get.find<IOrderRepository>()),
    );
  }
}
