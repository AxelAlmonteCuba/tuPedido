class MenuItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category; // 'todos', 'platos', 'entradas', 'postres'
  final String? imageUrl;

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    this.imageUrl,
  });
}

class OrderItem {
  final MenuItem menuItem;
  int quantity;
  String? notes;

  OrderItem({
    required this.menuItem,
    this.quantity = 1,
    this.notes,
  });

  double get totalPrice => menuItem.price * quantity;
}