import 'package:flutter/material.dart';
import '../../../core/models/menu_item.dart';
import '../widgets/order_item_card.dart';

class OrderConfirmationScreen extends StatefulWidget {
  final List<OrderItem> orderItems;

  const OrderConfirmationScreen({
    Key? key,
    required this.orderItems,
  }) : super(key: key);

  @override
  State<OrderConfirmationScreen> createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  String selectedTable = 'Mesa 1';
  String waiterName = '';
  late List<OrderItem> orderItems;

  @override
  void initState() {
    super.initState();
    orderItems = List.from(widget.orderItems);
  }

  double get totalAmount {
    return orderItems.fold(0, (sum, item) => sum + item.totalPrice);
  }

  void increaseQuantity(int index) {
    setState(() {
      orderItems[index].quantity++;
    });
  }

  void decreaseQuantity(int index) {
    setState(() {
      if (orderItems[index].quantity > 1) {
        orderItems[index].quantity--;
      }
    });
  }

  void removeItem(int index) {
    setState(() {
      orderItems.removeAt(index);
    });
    
    if (orderItems.isEmpty) {
      Navigator.pop(context);
    }
  }

  void sendToKitchen() {
    if (waiterName.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor ingresa el nombre del mesero'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Aquí enviarías el pedido a la cocina
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pedido Enviado'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mesa: $selectedTable'),
            Text('Mesero: $waiterName'),
            Text('Items: ${orderItems.length}'),
            Text('Total: \$${totalAmount.toStringAsFixed(2)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Cerrar diálogo
              Navigator.pop(context, true); // Volver al menú
            },
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
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
          'Confirmar Pedido',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Column(
        children: [
          // Selector de mesa y mesero
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Selector de mesa
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedTable,
                      isExpanded: true,
                      hint: const Text('Mesa'),
                      items: List.generate(
                        10,
                        (index) => DropdownMenuItem(
                          value: 'Mesa ${index + 1}',
                          child: Text('Mesa ${index + 1}'),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          selectedTable = value!;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                
                // Campo de mesero
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Tu nombre',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      waiterName = value;
                    });
                  },
                ),
              ],
            ),
          ),
          
          // Título de items
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            margin: const EdgeInsets.only(top: 8),
            child: const Text(
              'Ítems del Pedido',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          // Lista de items del pedido
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 100),
              itemCount: orderItems.length,
              itemBuilder: (context, index) {
                return OrderItemCard(
                  orderItem: orderItems[index],
                  onIncrease: () => increaseQuantity(index),
                  onDecrease: () => decreaseQuantity(index),
                  onRemove: () => removeItem(index),
                  onNotesChanged: (notes) {
                    orderItems[index].notes = notes;
                  },
                );
              },
            ),
          ),
        ],
      ),
      
      // Total y botón de enviar
      bottomSheet: Container(
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '\$${totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF5722),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Botón de enviar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: sendToKitchen,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF5722),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.send),
                    SizedBox(width: 8),
                    Text(
                      'Enviar a Cocina',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}