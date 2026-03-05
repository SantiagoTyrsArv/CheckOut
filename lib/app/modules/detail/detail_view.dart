import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/game_model.dart';
import '../cart/cart_controller.dart';

class DetailView extends StatelessWidget {
  const DetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final GameModel game = Get.arguments as GameModel;
    final CartController cart = Get.find<CartController>();

    return Scaffold(
      backgroundColor: AppTheme.backgroundGrey,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(game),
          SliverToBoxAdapter(child: _buildBody(game, cart)),
        ],
      ),
    );
  }

  Widget _buildAppBar(GameModel game) {
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      backgroundColor: AppTheme.cardWhite,
      leading: GestureDetector(
        onTap: Get.back,
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_back, color: AppTheme.textDark),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: CachedNetworkImage(
          imageUrl: game.imageUrl,
          fit: BoxFit.cover,
          errorWidget: (_, __, ___) => Container(
            color: AppTheme.lightBlue,
            child: const Center(
              child: Icon(Icons.videogame_asset,
                  size: 64, color: AppTheme.primaryBlue),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(GameModel game, CartController cart) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título y género
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(game.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDark,
                    )),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.lightBlue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(game.genre,
                    style: const TextStyle(
                      color: AppTheme.primaryBlue,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    )),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Rating y reseñas
          Row(
            children: [
              ...List.generate(5, (i) {
                final filled = i < game.rating.floor();
                return Icon(
                  filled ? Icons.star : Icons.star_border,
                  size: 18,
                  color: Colors.amber,
                );
              }),
              const SizedBox(width: 8),
              Text('${game.rating}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  )),
              const SizedBox(width: 4),
              Text('(${game.reviews} reseñas)',
                  style: const TextStyle(
                      color: AppTheme.textGrey, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 16),

          // Precio
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                game.price == 0
                    ? 'GRATIS'
                    : '\$${game.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryBlue,
                ),
              ),
              if (game.hasDiscount) ...[
                const SizedBox(width: 10),
                Text('\$${game.originalPrice!.toStringAsFixed(2)}',
                    style: const TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: AppTheme.textGrey,
                      fontSize: 16,
                    )),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('-${game.discountPercent}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      )),
                ),
              ],
            ],
          ),
          const SizedBox(height: 20),

          // Descripción
          const Text('Descripción',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.textDark,
              )),
          const SizedBox(height: 8),
          Text(
            _getDescription(game.id),
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textGrey,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 24),

          // Detalles técnicos
          _buildDetailChips(),
          const SizedBox(height: 32),

          // Botón agregar al carrito
          Obx(() {
            final inCart = cart.isInCart(game.id);
            return ElevatedButton.icon(
              onPressed: () => cart.addToCart(game),
              icon: Icon(
                inCart ? Icons.shopping_cart : Icons.add_shopping_cart,
              ),
              label: Text(inCart ? 'Agregar otro' : 'Agregar al carrito'),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                inCart ? Colors.green : AppTheme.primaryBlue,
              ),
            );
          }),
          const SizedBox(height: 12),

          // Botón ver carrito
          Obx(() {
            if (!cart.isInCart(game.id)) return const SizedBox.shrink();
            return OutlinedButton.icon(
              onPressed: () => Get.toNamed('/cart'),
              icon: const Icon(Icons.shopping_cart_outlined,
                  color: AppTheme.primaryBlue),
              label: Text(
                'Ver carrito (${cart.totalItems})',
                style: const TextStyle(color: AppTheme.primaryBlue),
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 54),
                side: const BorderSide(color: AppTheme.primaryBlue),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            );
          }),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDetailChips() {
    final details = [
      {'icon': Icons.devices, 'label': 'PC / Consola'},
      {'icon': Icons.language, 'label': 'Español'},
      {'icon': Icons.cloud_download, 'label': 'Digital'},
      {'icon': Icons.person, 'label': 'Un jugador'},
    ];
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: details.map((d) {
        return Container(
          padding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: AppTheme.lightBlue,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(d['icon'] as IconData,
                  size: 16, color: AppTheme.primaryBlue),
              const SizedBox(width: 6),
              Text(d['label'] as String,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.primaryBlue,
                    fontWeight: FontWeight.w500,
                  )),
            ],
          ),
        );
      }).toList(),
    );
  }

  String _getDescription(String id) {
    const descriptions = {
      '1': 'Cyberpunk 2077 es un RPG de mundo abierto ambientado en Night City, una megalópolis obsesionada con el poder, el glamur y la modificación corporal.',
      '2': 'God of War Ragnarök es la épica continuación de la saga nórdica, donde Kratos y Atreus deben enfrentar el inevitable Ragnarök y sus consecuencias.',
      '3': 'Elden Ring es un RPG de acción en mundo abierto desarrollado por FromSoftware en colaboración con George R.R. Martin. Un viaje épico por Las Tierras Intermedias.',
      '4': 'EA Sports FC 24 ofrece la experiencia de fútbol más auténtica con HyperMotionV, nuevos modos de juego y licencias de los mejores equipos del mundo.',
      '5': 'Resident Evil 4 Remake revive el clásico de terror y acción con gráficos modernos, mecánicas renovadas y una historia que te mantendrá al borde del asiento.',
      '6': 'StarCraft II es el legendario juego de estrategia en tiempo real de Blizzard. Ahora disponible de forma gratuita para todos los jugadores.',
    };
    return descriptions[id] ??
        'Un increíble videojuego que no te puedes perder. Horas de entretenimiento garantizado.';
  }
}
