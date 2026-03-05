import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../core/theme/app_theme.dart';
import 'checkout_controller.dart';

class PaymentDataView extends GetView<CheckoutController> {
  const PaymentDataView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundGrey,
      appBar: AppBar(
        title: const Text('Payment data'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: Get.back,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TotalPrice(),
              const SizedBox(height: 24),
              _PaymentMethodSelector(),
              const SizedBox(height: 24),
              _CardForm(),
              const SizedBox(height: 20),
              _SaveCardToggle(),
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: controller.proceedToConfirm,
                child: const Text('Proceed to confirm'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _TotalPrice extends GetView<CheckoutController> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Total price',
            style: TextStyle(fontSize: 14, color: AppTheme.textGrey)),
        const SizedBox(height: 4),
        Obx(() => Text(
          '\$${controller.totalPrice.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryBlue,
          ),
        )),
      ],
    );
  }
}

class _PaymentMethodSelector extends GetView<CheckoutController> {
  static const _methods = [
    {'key': 'paypal', 'label': 'PayPal'},
    {'key': 'credit', 'label': 'Credit'},
    {'key': 'wallet', 'label': 'Wallet'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Payment Method',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.textDark,
            )),
        const SizedBox(height: 10),
        GetX<CheckoutController>(
          builder: (ctrl) => Row(
            children: _methods.map((m) {
              final isSelected = ctrl.selectedPayment.value == m['key'];
              return Expanded(
                child: GestureDetector(
                  onTap: () => ctrl.selectPayment(m['key']!),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primaryBlue
                          : AppTheme.lightBlue,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: isSelected
                          ? [
                        BoxShadow(
                          color: AppTheme.primaryBlue
                              .withValues(alpha: 0.35),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        )
                      ]
                          : [],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(m['label']!,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : AppTheme.primaryBlue,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            )),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.check_circle,
                          size: 16,
                          color: isSelected
                              ? Colors.white
                              : AppTheme.primaryBlue.withValues(alpha: 0.4),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _CardForm extends GetView<CheckoutController> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('Card number'),
        _cardNumberField(),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label('Valid until'),
                  _validUntilField(),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label('CVV'),
                  _cvvField(),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _label('Card holder'),
        _cardHolderField(),
      ],
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppTheme.textDark,
        )),
  );

  Widget _inputBox({required Widget child}) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
    decoration: BoxDecoration(
      color: AppTheme.cardWhite,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: child,
  );

  Widget _cardNumberField() => _inputBox(
    child: Row(
      children: [
        _masterCardIcon(),
        const SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            controller: controller.cardNumberController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(16),
              _CardNumberFormatter(),
            ],
            decoration: const InputDecoration(
              hintText: '**** **** **** ****',
              border: InputBorder.none,
              hintStyle:
              TextStyle(color: AppTheme.textGrey, fontSize: 14),
            ),
            validator: (v) =>
            (v == null || v.replaceAll(' ', '').length < 16)
                ? 'Número inválido'
                : null,
          ),
        ),
      ],
    ),
  );

  Widget _validUntilField() => _inputBox(
    child: TextFormField(
      controller: controller.validUntilController,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(4),
        _DateFormatter(),
      ],
      decoration: const InputDecoration(
        hintText: 'Month / Year',
        border: InputBorder.none,
        hintStyle: TextStyle(color: AppTheme.textGrey, fontSize: 13),
      ),
      validator: (v) =>
      (v == null || v.isEmpty) ? 'Requerido' : null,
    ),
  );

  Widget _cvvField() => _inputBox(
    child: TextFormField(
      controller: controller.cvvController,
      keyboardType: TextInputType.number,
      obscureText: true,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(3),
      ],
      decoration: const InputDecoration(
        hintText: '***',
        border: InputBorder.none,
        hintStyle: TextStyle(color: AppTheme.textGrey),
      ),
      validator: (v) =>
      (v == null || v.length < 3) ? 'CVV inválido' : null,
    ),
  );

  Widget _cardHolderField() => _inputBox(
    child: TextFormField(
      controller: controller.cardHolderController,
      textCapitalization: TextCapitalization.words,
      decoration: const InputDecoration(
        hintText: 'Your name and surname',
        border: InputBorder.none,
        hintStyle: TextStyle(color: AppTheme.textGrey, fontSize: 13),
      ),
      validator: (v) =>
      (v == null || v.trim().isEmpty) ? 'Ingresa tu nombre' : null,
    ),
  );

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

class _SaveCardToggle extends GetView<CheckoutController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.cardWhite,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Save card data for future payments',
              style: TextStyle(fontSize: 13, color: AppTheme.textDark)),
          GetX<CheckoutController>(
            builder: (ctrl) => Switch(
              value: ctrl.saveCard.value,
              onChanged: ctrl.toggleSaveCard,
              activeThumbColor: AppTheme.primaryBlue,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Formatters ────────────────────────────────────────────────────────────────

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue old, TextEditingValue newVal) {
    final digits = newVal.text.replaceAll(' ', '');
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(digits[i]);
    }
    return newVal.copyWith(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

class _DateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue old, TextEditingValue newVal) {
    final digits = newVal.text;
    if (digits.length == 2 && old.text.length == 1) {
      return newVal.copyWith(
        text: '$digits/',
        selection: const TextSelection.collapsed(offset: 3),
      );
    }
    return newVal;
  }
}
