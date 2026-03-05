import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/order_model.dart';
import '../../data/models/saved_card_model.dart';
import '../../data/repositories/order_repository.dart';
import '../../routes/app_routes.dart';
import '../cart/cart_controller.dart';

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
  final RxBool hasSavedCard = false.obs;

  // ── Datos internos
  double _cartTotal = 0.0;
  SavedCardModel? _savedCard;

  static const _validPromo = 'PROMO20-08';
  static const _promoDiscount = 50.0;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>;
    _cartTotal = (args['total'] as num).toDouble();
    _loadSavedCard();
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

  // ── Getters
  double get totalPrice =>
      (_cartTotal - discount.value).clamp(0.0, double.infinity);

  // ── Cargar tarjeta guardada desde Hive
  void _loadSavedCard() {
    _savedCard = _repository.getSavedCard();
    hasSavedCard.value = _savedCard != null;
  }

  /// Autocompleta el formulario con la tarjeta guardada en Hive
  void autoFillCard() {
    if (_savedCard == null) return;
    cardNumberController.text = _savedCard!.cardNumber;
    cardHolderController.text = _savedCard!.cardHolder;
    validUntilController.text = _savedCard!.validUntil;
    selectedPayment.value = _savedCard!.paymentMethod;
    Get.snackbar(
      '✅ Autocompletado',
      'Datos de tarjeta cargados correctamente',
      backgroundColor: Colors.green.withValues(alpha: 0.9),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

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
        'El código ingresado no es válido',
        backgroundColor: Colors.redAccent.withValues(alpha: 0.9),
        colorText: Colors.white,
      );
    }
  }

  void proceedToConfirm() {
    if (formKey.currentState?.validate() ?? false) {
      final rawNumber = cardNumberController.text.replaceAll(' ', '');
      final displayCard = rawNumber.length >= 4
          ? '**${rawNumber.substring(rawNumber.length - 4)}'
          : '****';

      // ── Guardar tarjeta en Hive si el toggle está activo
      if (saveCard.value) {
        _repository.saveCard(SavedCardModel(
          cardNumber: cardNumberController.text.trim(),
          cardHolder: cardHolderController.text.trim(),
          validUntil: validUntilController.text.trim(),
          paymentMethod: selectedPayment.value,
        ));
      }

      final order = OrderModel(
        id: const Uuid().v4(),
        gameId: 'cart',
        gameTitle: 'Carrito de compras',
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

    // Verificación en consola
    final orders = _repository.fetchOrders();
    debugPrint('📦 Órdenes guardadas en Hive: ${orders.length}');
    for (final o in orders) {
      debugPrint(
          '  → ${o.id} | ${o.gameTitle} | \$${o.totalPrice} | ${o.cardHolder}');
    }

    Get.find<CartController>().clearCart();
    isLoading.value = false;

    Get.offAllNamed(AppRoutes.home);
    Get.snackbar(
      '✅ Pago exitoso',
      '¡Gracias por tu compra! Total: \$${order.totalPrice.toStringAsFixed(2)}',
      duration: const Duration(seconds: 4),
      backgroundColor: Colors.green.withValues(alpha: 0.95),
      colorText: Colors.white,
    );
  }
}
