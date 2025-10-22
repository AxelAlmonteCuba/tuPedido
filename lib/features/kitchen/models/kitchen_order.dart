import '../../../core/models/menu_item.dart'; // Asegúrate que esta ruta sea correcta

enum OrderStatus {
  pendiente,
  enPreparacion,
  listo,
  entregado, // Agregado para el estado final en el ejemplo 'listos.png'
}

class KitchenOrder {
  final String orderId;
  final String table;
  final String waiter;
  final OrderStatus status;
  final List<OrderItem> items;
  final int timeInMinutes; // Tiempo que lleva la orden en el estado actual (simulado)

  KitchenOrder({
    required this.orderId,
    required this.table,
    required this.waiter,
    required this.status,
    required this.items,
    required this.timeInMinutes,
  });
}

// Datos de ejemplo para simular la interfaz
final List<KitchenOrder> dummyKitchenOrders = [
  // Pedido #002 (Pendiente - imagen.png)
  KitchenOrder(
    orderId: '002',
    table: 'Mesa 3',
    waiter: 'Carlos',
    status: OrderStatus.pendiente,
    timeInMinutes: 7,
    items: [
      OrderItem(
        menuItem: MenuItem(
          id: '4',
          name: 'Pasta Carbonara',
          description: 'Pasta con salsa cremosa, panceta y queso parmesano',
          price: 14.99,
          category: 'platos',
        ),
      ),
      OrderItem(
        menuItem: MenuItem(
          id: '3',
          name: 'Sopa de Pollo',
          description: 'Sopa casera con pollo, fideos y vegetales',
          price: 7.99,
          category: 'entradas',
        ),
      ),
    ],
  ),

  // Pedido #001 (En Preparación - en_preparacion.png)
  KitchenOrder(
    orderId: '001',
    table: 'Mesa 5',
    waiter: 'María',
    status: OrderStatus.enPreparacion,
    timeInMinutes: 20,
    items: [
      OrderItem(
        menuItem: MenuItem(
          id: '1',
          name: 'Bife a la Parrilla',
          description: 'Jugoso bife de res con guarnición de papas y...',
          price: 18.99,
          category: 'platos',
        ),
        notes: 'Término medio', // Nota especial del mesero
        quantity: 1,
      ),
      OrderItem(
        menuItem: MenuItem(
          id: '2',
          name: 'Ensalada César',
          description: 'Lechuga fresca, crutones, queso parmesano y aderezo César',
          price: 9.99,
          category: 'entradas',
        ),
      ),
    ],
  ),

  // Pedido #003 (Listo - listos.png)
  KitchenOrder(
    orderId: '003',
    table: 'Mesa 8',
    waiter: 'María',
    status: OrderStatus.listo,
    timeInMinutes: 30, // Asumiremos que este es el tiempo que estuvo en preparación/listo
    items: [
      OrderItem(
        menuItem: MenuItem(
          id: '5',
          name: 'Salmón a la Parrilla',
          description: 'Salmón fresco con limón y hierbas aromáticas',
          price: 22.99,
          category: 'platos',
        ),
      ),
      OrderItem(
        menuItem: MenuItem(
          id: '6',
          name: 'Tiramisú',
          description: 'Postre italiano tradicional con café y mascarpone',
          price: 8.99,
          category: 'postres',
        ),
      ),
    ],
  ),
];