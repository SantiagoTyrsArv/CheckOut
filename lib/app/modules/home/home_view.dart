import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/models/game_model.dart';
import '../../core/theme/app_theme.dart';
import '../../routes/app_routes.dart';
import '../cart/cart_controller.dart';
import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundGrey,
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            // ── Header + SearchBar + Categorías (siempre visible)
            SliverToBoxAdapter(child: _buildHeader()),
            SliverToBoxAdapter(child: _buildSearchBar()),
            SliverToBoxAdapter(child: _buildCategories()),

            // ── Destacados (se oculta al hacer scroll)
            SliverAppBar(
              automaticallyImplyLeading: false,
              backgroundColor: AppTheme.backgroundGrey,
              expandedHeight: 220,
              floating: true,   // aparece al subir
              snap: true,       // animación instantánea
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.none,
                background: _buildFeaturedSection(),
              ),
            ),
          ],
          body: _buildGamesGrid(),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('GameStore 🎮',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  )),
              Text('Encuentra tu próximo juego',
                  style:
                  TextStyle(fontSize: 13, color: AppTheme.textGrey)),
            ],
          ),
          Row(
            children: [
              // ── Ícono carrito con badge
              Obx(() {
                final cart = Get.find<CartController>();
                final count = cart.totalItems;
                return GestureDetector(
                  onTap: () => Get.toNamed(AppRoutes.cart),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.cardWhite,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.06),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.shopping_cart_outlined,
                            color: AppTheme.primaryBlue),
                      ),
                      if (count > 0)
                        Positioned(
                          top: -4,
                          right: -4,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.redAccent,
                              shape: BoxShape.circle,
                            ),
                            child: Text('$count',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ),
                    ],
                  ),
                );
              }),
              const SizedBox(width: 10),
              // ── Botón ver Hive (solo para demostración académica)
              IconButton(
                onPressed: () => Get.toNamed(AppRoutes.orders),
                icon: const Icon(Icons.storage,
                    color: AppTheme.primaryBlue),
                tooltip: 'Ver Hive',
              ),
              const CircleAvatar(
                backgroundColor: AppTheme.primaryBlue,
                child: Icon(Icons.person, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        onChanged: (v) => controller.searchQuery.value = v,
        decoration: InputDecoration(
          hintText: 'Buscar videojuegos...',
          hintStyle: const TextStyle(color: AppTheme.textGrey),
          prefixIcon:
          const Icon(Icons.search, color: AppTheme.primaryBlue),
          filled: true,
          fillColor: AppTheme.cardWhite,
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 42,
      child: Obx(() {
        final selected = controller.selectedCategory.value;
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemCount: controller.categories.length,
          itemBuilder: (_, i) {
            final cat = controller.categories[i];
            final isSelected = selected == cat;
            return GestureDetector(
              onTap: () => controller.selectedCategory.value = cat,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.primaryBlue
                      : AppTheme.cardWhite,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: isSelected
                      ? [
                    BoxShadow(
                      color: AppTheme.primaryBlue
                          .withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    )
                  ]
                      : [],
                ),
                child: Text(cat,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : AppTheme.textDark,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      fontSize: 13,
                    )),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildFeaturedSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Destacados',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.textDark,
              )),
          const SizedBox(height: 10),
          SizedBox(
            height: 170,
            child: Obx(() {
              final games = controller.featuredGames;
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: games.length,
                itemBuilder: (_, i) {
                  final game = games[i];
                  return _FeaturedCard(
                    game: game,
                    onTap: () => controller.goToCheckout(game),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildGamesGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text('Todos los juegos',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                )),
          ),
          Expanded(
            child: Obx(() {
              final games = controller.filteredGames;
              if (games.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off,
                          size: 60, color: AppTheme.textGrey),
                      SizedBox(height: 12),
                      Text('No se encontraron juegos',
                          style: TextStyle(
                              color: AppTheme.textGrey, fontSize: 15)),
                    ],
                  ),
                );
              }
              return GridView.builder(
                padding: const EdgeInsets.only(bottom: 20),
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.72,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: games.length,
                itemBuilder: (_, i) {
                  final game = games[i];
                  return _GameCard(
                    game: game,
                    onTap: () => controller.goToCheckout(game),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ─── Widgets privados ──────────────────────────────────────────────────────────

class _FeaturedCard extends StatelessWidget {
  final GameModel game;
  final VoidCallback onTap;

  const _FeaturedCard({required this.game, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 260,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [AppTheme.primaryBlue, Color(0xFF6B8EFF)],
          ),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CachedNetworkImage(
                imageUrl: game.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                colorBlendMode: BlendMode.darken,
                color: Colors.black38,
                placeholder: (_, __) => Container(
                  color: AppTheme.lightBlue,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.primaryBlue,
                      strokeWidth: 2,
                    ),
                  ),
                ),
                errorWidget: (_, __, ___) => Container(
                  color: AppTheme.lightBlue,
                  child: const Center(
                    child: Icon(Icons.videogame_asset,
                        color: AppTheme.primaryBlue, size: 32),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(game.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      )),
                  Text('\$${game.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 13)),
                ],
              ),
            ),
            if (game.hasDiscount)
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text('-${game.discountPercent}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _GameCard extends StatelessWidget {
  final GameModel game;
  final VoidCallback onTap;

  const _GameCard({required this.game, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.cardWhite,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(16)),
              child: CachedNetworkImage(
                imageUrl: game.imageUrl,
                height: 110,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  height: 110,
                  color: AppTheme.lightBlue,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.primaryBlue,
                      strokeWidth: 2,
                    ),
                  ),
                ),
                errorWidget: (_, __, ___) => Container(
                  height: 110,
                  color: AppTheme.lightBlue,
                  child: const Center(
                    child: Icon(Icons.videogame_asset,
                        color: AppTheme.primaryBlue, size: 32),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(game.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: AppTheme.textDark,
                      )),
                  const SizedBox(height: 2),
                  Text(game.genre,
                      style: const TextStyle(
                          fontSize: 11, color: AppTheme.textGrey)),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('\$${game.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: AppTheme.primaryBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          )),
                      if (game.hasDiscount)
                        Text(
                          '\$${game.originalPrice!.toStringAsFixed(2)}',
                          style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: AppTheme.textGrey,
                            fontSize: 11,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star,
                          size: 12, color: Colors.amber),
                      const SizedBox(width: 2),
                      Text('${game.rating}',
                          style: const TextStyle(
                              fontSize: 11,
                              color: AppTheme.textGrey)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
