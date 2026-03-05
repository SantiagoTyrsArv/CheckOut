import 'package:get/get.dart';
import '../bindings/cart_binding.dart';
import '../bindings/checkout_binding.dart';
import '../bindings/home_binding.dart';
import '../modules/cart/cart_view.dart';
import '../modules/checkout/payment_confirm_view.dart';
import '../modules/checkout/payment_data_view.dart';
import '../modules/detail/detail_view.dart';
import '../modules/home/home_view.dart';
import '../modules/orders/orders_view.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.detail,
      page: () => const DetailView(),
    ),
    GetPage(
      name: AppRoutes.cart,
      page: () => const CartView(),
    ),
    GetPage(
      name: AppRoutes.orders,
      page: () => const OrdersView(),
    ),
    GetPage(
      name: AppRoutes.paymentData,
      page: () => const PaymentDataView(),
      binding: CheckoutBinding(),
    ),
    GetPage(
      name: AppRoutes.payment,
      page: () => const PaymentConfirmView(),
      binding: CheckoutBinding(),
    ),
  ];
}
