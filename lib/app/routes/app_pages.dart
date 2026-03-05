import 'package:get/get.dart';
import '../bindings/checkout_binding.dart';
import '../bindings/home_binding.dart';
import '../modules/checkout/payment_confirm_view.dart';
import '../modules/checkout/payment_data_view.dart';
import '../modules/home/home_view.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
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
