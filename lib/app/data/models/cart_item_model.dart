class CartItemModel {
  final String gameId;
  final String title;
  final double price;
  final String imageUrl;
  int quantity;

  CartItemModel({
    required this.gameId,
    required this.title,
    required this.price,
    required this.imageUrl,
    this.quantity = 1,
  });

  double get subtotal => price * quantity;
}
