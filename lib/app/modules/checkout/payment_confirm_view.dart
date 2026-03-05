import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/order_model.dart';
import 'checkout_controller.dart';

class PaymentConfirmView extends GetView<CheckoutController> {
  const PaymentConfirmView({super.key});

  @override
  Widget build(BuildContext context) {
    final order = Get.arguments as OrderModel;

    return Scaffold(
      backgroundColor: AppTheme.backgroundGrey,
      appBar: AppBar(
        title: const Text('Payment'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: Get.back,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PromoCard(gameTitle: order.gameTitle),
            const SizedBox(height: 24),
            _PaymentInfo(order: order),
            const SizedBox(height: 20),
            _PromoCodeField(),
            const SizedBox(height: 28),
            GetX<CheckoutController>(
              builder: (ctrl) => ElevatedButton(
                onPressed: ctrl.isLoading.value ? null : ctrl.pay,
                child: ctrl.isLoading.value
                    ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                    : const Text('Pay'),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _PromoCard extends StatelessWidget {
  final String gameTitle;
  const _PromoCard({required this.gameTitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4B6EFF), Color(0xFF7B5EA7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.sports_esports, color: Colors.white, size: 28),
          const SizedBox(height: 12),
          const Text('\$50 off',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              )),
          const SizedBox(height: 4),
          Text('On your first order — $gameTitle',
              style:
              const TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 12),
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              '* Promo code valid for orders over \$150.',
              style: TextStyle(color: Colors.white70, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentInfo extends StatelessWidget {
  final OrderModel order;
  const _PaymentInfo({required this.order});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Payment information',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: AppTheme.textDark,
                )),
            GestureDetector(
              onTap: Get.back,
              child: const Text('Edit',
                  style: TextStyle(
                    color: AppTheme.primaryBlue,
                    fontWeight: FontWeight.w500,
                  )),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.lightBlue,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              _masterCardIcon(),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.cardHolder.isNotEmpty
                        ? order.cardHolder
                        : 'Card holder',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppTheme.textDark,
                    ),
                  ),
                  Text('Master Card ending ${order.cardNumber}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textGrey,
                      )),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _masterCardIcon() => SizedBox(
    width: 48,
    height: 28,
    child: Stack(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: const BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
        ),
        Positioned(
          left: 14,
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.85),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    ),
  );
}

class _PromoCodeField extends GetView<CheckoutController> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Use promo code',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.textDark,
            )),
        const SizedBox(height: 8),
        Container(
          padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.cardWhite,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller.promoController,
                  textCapitalization: TextCapitalization.characters,
                  decoration: const InputDecoration(
                    hintText: 'PROMO20-08',
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: AppTheme.primaryBlue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: controller.applyPromoCode,
                child: const Text('Aplicar',
                    style: TextStyle(color: AppTheme.primaryBlue)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
