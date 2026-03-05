class GameModel {
  final String id;
  final String title;
  final String genre;
  final double price;
  final double? originalPrice;
  final String imageUrl;
  final double rating;
  final int reviews;
  final bool isFeatured;

  const GameModel({
    required this.id,
    required this.title,
    required this.genre,
    required this.price,
    this.originalPrice,
    required this.imageUrl,
    required this.rating,
    required this.reviews,
    this.isFeatured = false,
  });

  bool get hasDiscount => originalPrice != null && originalPrice! > price;

  int get discountPercent => hasDiscount
      ? (((originalPrice! - price) / originalPrice!) * 100).round()
      : 0;
}
