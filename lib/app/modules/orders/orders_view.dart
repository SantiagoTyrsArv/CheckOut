import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_theme.dart';
import '../../data/providers/hive_provider.dart';

class OrdersView extends StatelessWidget {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = HiveProvider();
    final orders = provider.getAllOrders();
    final savedCard = provider.getSavedCard();

    return Scaffold(
      backgroundColor: AppTheme.backgroundGrey,
      appBar: AppBar(
        title: const Text('Datos en Hive'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: Get.back,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Tarjeta guardada
          const Text('🗂 Tarjeta guardada',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppTheme.textDark,
              )),
          const SizedBox(height: 8),
          savedCard == null
              ? _emptyBox('No hay tarjeta guardada')
              : _infoCard([
            _row('Titular', savedCard.cardHolder),
            _row('Número', savedCard.cardNumber),
            _row('Vence', savedCard.validUntil),
            _row('Método', savedCard.paymentMethod),
          ]),
          const SizedBox(height: 24),

          // ── Órdenes guardadas
          Text('📦 Órdenes guardadas (${orders.length})',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppTheme.textDark,
              )),
          const SizedBox(height: 8),
          if (orders.isEmpty) _emptyBox('No hay órdenes guardadas'),
          ...orders.map(
                (o) => _infoCard([
              _row('ID', '${o.id.substring(0, 8)}...'),
              _row('Juego', o.gameTitle),
              _row('Total', '\$${o.totalPrice.toStringAsFixed(2)}'),
              _row('Método', o.paymentMethod),
              _row('Titular', o.cardHolder),
              _row('Tarjeta', o.cardNumber),
              _row('Descuento', '\$${o.discount.toStringAsFixed(2)}'),
              _row('Fecha', o.createdAt.toString().substring(0, 16)),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _emptyBox(String msg) => Container(
    padding: const EdgeInsets.all(16),
    margin: const EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(
      color: AppTheme.cardWhite,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(msg,
        style: const TextStyle(color: AppTheme.textGrey)),
  );

  Widget _infoCard(List<Widget> rows) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: AppTheme.cardWhite,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(children: rows),
  );

  Widget _row(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(
              color: AppTheme.textGrey,
              fontSize: 13,
            )),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              color: AppTheme.textDark,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ],
    ),
  );
}
