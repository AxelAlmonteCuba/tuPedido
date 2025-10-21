import 'package:flutter/material.dart';
import '../../../core/models/menu_item.dart';
import '../widgets/menu_item_card.dart';
import '../../order/screens/order_confirmation_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String selectedCategory = 'Todos';
  List<OrderItem> cart = [];

  // Datos de ejemplo del menú
  final List<MenuItem> menuItems = [
    MenuItem(
      id: '1',
      name: 'Bife a la Parrilla',
      description: 'Jugoso bife de res con guarnición de papas y...',
      price: 18.99,
      category: 'platos',
    ),
    MenuItem(
      id: '2',
      name: 'Ensalada César',
      description: 'Lechuga fresca, crutones, queso parmesano y aderezo César',
      price: 9.99,
      category: 'entradas',
    ),
    MenuItem(
      id: '3',
      name: 'Sopa de Pollo',
      description: 'Sopa casera con pollo, fideos y vegetales',
      price: 7.99,
      category: 'entradas',
    ),
    MenuItem(
      id: '4',
      name: 'Pasta Carbonara',
      description: 'Pasta con salsa cremosa, panceta y queso parmesano',
      price: 14.99,
      category: 'platos',
    ),
    MenuItem(
      id: '5',
      name: 'Salmón a la Parrilla',
      description: 'Salmón fresco con limón y hierbas aromáticas',
      price: 22.99,
      category: 'platos',
    ),
    MenuItem(
      id: '6',
      name: 'Tiramisú',
      description: 'Postre italiano tradicional con café y mascarpone',
      price: 8.99,
      category: 'postres',
    ),
    MenuItem(
      id: '7',
      name: 'Flan Casero',
      description: 'Flan cremoso con caramelo',
      price: 6.99,
      category: 'postres',
    ),
  ];

  List<MenuItem> get filteredItems {
    if (selectedCategory == 'Todos') {
      return menuItems;
    }
    return menuItems
        .where((item) => item.category == selectedCategory.toLowerCase())
        .toList();
  }

  int getQuantityInCart(String itemId) {
    final orderItem = cart.firstWhere(
      (item) => item.menuItem.id == itemId,
      orElse: () => OrderItem(
        menuItem: MenuItem(
          id: '',
          name: '',
          description: '',
          price: 0,
          category: '',
        ),
        quantity: 0,
      ),
    );
    return orderItem.quantity;
  }

  void addToCart(MenuItem item) {
    setState(() {
      final existingIndex =
          cart.indexWhere((orderItem) => orderItem.menuItem.id == item.id);
      
      if (existingIndex != -1) {
        cart[existingIndex].quantity++;
      } else {
        cart.add(OrderItem(menuItem: item));
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.name} agregado al pedido'),
        duration: const Duration(seconds: 1),
        backgroundColor: const Color(0xFFFF5722),
      ),
    );
  }

  int get totalItemsInCart {
    return cart.fold(0, (sum, item) => sum + item.quantity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Menú del Día',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Column(
        children: [
          // Pestañas de categorías
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildCategoryTab('Todos'),
                  const SizedBox(width: 8),
                  _buildCategoryTab('Platos'),
                  const SizedBox(width: 8),
                  _buildCategoryTab('Entradas'),
                  const SizedBox(width: 8),
                  _buildCategoryTab('Postres'),
                ],
              ),
            ),
          ),
          
          // Lista de items del menú
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 80),
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                final item = filteredItems[index];
                return MenuItemCard(
                  item: item,
                  quantityInCart: getQuantityInCart(item.id),
                  onAdd: () => addToCart(item),
                );
              },
            ),
          ),
        ],
      ),
      
      // Botón flotante para ver pedido
      bottomSheet: cart.isNotEmpty
          ? Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderConfirmationScreen(
                        orderItems: cart,
                      ),
                    ),
                  ).then((value) {
                    // Si el pedido fue enviado, limpiar el carrito
                    if (value == true) {
                      setState(() {
                        cart.clear();
                      });
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF5722),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.shopping_cart),
                    const SizedBox(width: 8),
                    Text(
                      'Ver Pedido ($totalItemsInCart items)',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildCategoryTab(String category) {
    final isSelected = selectedCategory == category;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = category;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF5722) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFFFF5722) : Colors.grey[300]!,
          ),
        ),
        child: Text(
          category,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}