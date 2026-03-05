import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/game_model.dart';
import '../../data/models/order_model.dart';
import '../../data/repositories/order_repository.dart';
import '../../routes/app_routes.dart';

class CheckoutController extends GetxController {
  final IOrderRepository _repository;
  CheckoutController(this._repository);

  // ── Formulario
  final cardNumberController = TextEditingController();
  final validUntilController = TextEditingController();
  final cvvController = TextEditingController();
  final cardHolderController = TextEditingController();
  final promoController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // ── Estado observable
  final RxString selectedPayment = 'credit'.obs;
  final RxBool saveCard = true.obs;
  final RxDouble discount = 0.0.obs;
  final RxBool isLoading = false.obs;

  late GameModel currentGame;

  static const _validPromo = 'PROMO20-08';
  static const _promoDiscount = 50.0;

  @override
  void onInit() {
    super.onInit();
    currentGame = Get.arguments as GameModel;
  }

  @override
  void onClose() {
    cardNumberController.dispose();
    validUntilController.dispose();
    cvvController.dispose();
    cardHolderController.dispose();
    promoController.dispose();
    super.onClose();
  }

  double get totalPrice => currentGame.price - discount.value;

  void selectPayment(String method) => selectedPayment.value = method;

  void toggleSaveCard(bool val) => saveCard.value = val;

  void applyPromoCode() {
    if (promoController.text.trim().toUpperCase() == _validPromo) {
      discount.value = _promoDiscount;
      Get.snackbar(
        '¡Código aplicado!',
        '-\$$_promoDiscount de descuento',
        backgroundColor: Colors.green.withValues(alpha: 0.9),
        colorText: Colors.white,
      );
    } else {
      discount.value = 0.0;
      Get.snackbar(
        'Código inválido',
        'El código no es válido',
        backgroundColor: Colors.redAccent.withValues(alpha: 0.9),
        colorText: Colors.white,
      );
    }
  }

  void proceedToConfirm() {
    if (formKey.currentState?.validate() ?? false) {
      final last4 = cardNumberController.text.replaceAll(' ', '');
      final displayCard = last4.length >= 4
          ? '**${last4.substring(last4.length - 4)}'
          : '****';

      final order = OrderModel(
        id: const Uuid().v4(),
        gameId: currentGame.id,
        gameTitle: currentGame.title,
        totalPrice: totalPrice,
        paymentMethod: selectedPayment.value,
        cardNumber: displayCard,
        cardHolder: cardHolderController.text.trim(),
        validUntil: validUntilController.text.trim(),
        promoCode: promoController.text.trim(),
        saveCard: saveCard.value,
        createdAt: DateTime.now(),
        discount: discount.value,
      );

      Get.toNamed(AppRoutes.payment, arguments: order);
    }
  }

  Future<void> pay() async {
    isLoading.value = true;
    final order = Get.arguments as OrderModel;
    await _repository.placeOrder(order);
    isLoading.value = false;

    Get.offAllNamed(AppRoutes.home);
    Get.snackbar(
      '✅ Pago exitoso',
      '¡Gracias por tu compra de ${order.gameTitle}!',
      duration: const Duration(seconds: 4),
      backgroundColor: Colors.green.withValues(alpha: 0.95),
      colorText: Colors.white,
    );
  }
}
