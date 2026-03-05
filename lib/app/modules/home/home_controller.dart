import 'package:get/get.dart';
import '../../data/models/game_model.dart';
import '../../routes/app_routes.dart';

class HomeController extends GetxController {
  final RxString searchQuery = ''.obs;
  final RxString selectedCategory = 'All'.obs;

  final List<String> categories = [
    'All', 'Action', 'RPG', 'Sports', 'Strategy', 'Horror'
  ];

  final List<GameModel> _allGames = const [
    GameModel(
      id: '1', title: 'Cyberpunk 2077',
      genre: 'RPG', price: 39.99, originalPrice: 59.99,
      imageUrl: 'https://cdn.akamai.steamstatic.com/steam/apps/1091500/header.jpg',
      rating: 4.5, reviews: 12400, isFeatured: true,
    ),
    GameModel(
      id: '2', title: 'God of War Ragnarök',
      genre: 'Action', price: 49.99, originalPrice: 69.99,
      imageUrl: 'https://image.api.playstation.com/vulcan/ap/rnd/202207/1210/4xJ8XB3bi888QTLZYdl7Oi0s.png',
      rating: 4.9, reviews: 34200, isFeatured: true,
    ),
    GameModel(
      id: '3', title: 'Elden Ring',
      genre: 'RPG', price: 44.99,
      imageUrl: 'https://cdn.akamai.steamstatic.com/steam/apps/1245620/header.jpg',
      rating: 4.8, reviews: 28700,
    ),
    GameModel(
      id: '4', title: 'FIFA 24',
      genre: 'Sports', price: 29.99, originalPrice: 59.99,
      imageUrl: 'https://cdn.akamai.steamstatic.com/steam/apps/2195250/header.jpg',
      rating: 3.8, reviews: 9800,
    ),
    GameModel(
      id: '5', title: 'Resident Evil 4',
      genre: 'Horror', price: 34.99,
      imageUrl: 'https://cdn.akamai.steamstatic.com/steam/apps/2050650/header.jpg',
      rating: 4.7, reviews: 18300,
    ),
    GameModel(
      id: '6', title: 'StarCraft II',
      genre: 'Strategy', price: 0.00,
      imageUrl: 'https://cdn.akamai.steamstatic.com/steam/apps/1517290/header.jpg',
      rating: 4.6, reviews: 45200,
    ),
  ];

  // ── Listas reactivas que se reconstruyen al filtrar
  final RxList<GameModel> filteredGames = <GameModel>[].obs;
  final RxList<GameModel> featuredGames = <GameModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Inicializar listas
    _applyFilters();

    // Escuchar cambios en búsqueda y categoría
    ever(searchQuery, (_) => _applyFilters());
    ever(selectedCategory, (_) => _applyFilters());
  }

  void _applyFilters() {
    final query = searchQuery.value.toLowerCase();
    final category = selectedCategory.value;

    filteredGames.value = _allGames.where((g) {
      final matchesQuery = g.title.toLowerCase().contains(query);
      final matchesCategory = category == 'All' || g.genre == category;
      return matchesQuery && matchesCategory;
    }).toList();

    featuredGames.value = _allGames.where((g) => g.isFeatured).toList();
  }

  void goToCheckout(GameModel game) {
    Get.toNamed(AppRoutes.paymentData, arguments: game);
  }
}
