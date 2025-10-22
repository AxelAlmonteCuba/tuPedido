import 'package:flutter/material.dart';
import '../models/kitchen_order.dart';
import '../../../core/models/menu_item.dart'; 

class KitchenPanelItem extends StatelessWidget {
  final KitchenOrder order;
  final VoidCallback onActionPressed;
  final bool isSelected; // Para manejar el estilo del item seleccionado en el tab

  const KitchenPanelItem({
    Key? key,
    required this.order,
    required this.onActionPressed,
    this.isSelected = false,
  }) : super(key: key);

  // --- Helpers para el diseño de la tarjeta ---

  // Obtener el color principal basado en el estado
  Color _getStatusColor() {
    switch (order.status) {
      case OrderStatus.pendiente:
        return const Color(0xFFFFC107); // Amarillo (Para el badge y tiempo)
      case OrderStatus.enPreparacion:
        return const Color(0xFF2196F3); // Azul
      case OrderStatus.listo:
        return const Color(0xFF4CAF50); // Verde
      case OrderStatus.entregado:
        return Colors.grey; // Color neutro si se llega a mostrar
    }
  }

  // Obtener el texto del botón y su color
  Map<String, dynamic> _getActionButtonData() {
    switch (order.status) {
      case OrderStatus.pendiente:
        return {
          'text': 'Comenzar',
          'color': const Color(0xFFFF9800), // Naranja para empezar
          'textColor': Colors.white,
        };
      case OrderStatus.enPreparacion:
        return {
          'text': 'Marcar Listo',
          'color': const Color(0xFF2196F3), // Azul para listo
          'textColor': Colors.white,
        };
      case OrderStatus.listo:
        return {
          'text': 'Entregado',
          'color': const Color(0xFF4CAF50), // Verde para entregado
          'textColor': Colors.white,
        };
      case OrderStatus.entregado:
        return {
          'text': 'Completado',
          'color': Colors.grey[400],
          'textColor': Colors.white,
        };
    }
  }

  // Obtener el texto del badge
  String _getStatusText() {
    switch (order.status) {
      case OrderStatus.pendiente:
        return 'Pendiente';
      case OrderStatus.enPreparacion:
        return 'En Preparación';
      case OrderStatus.listo:
        return 'Listo';
      case OrderStatus.entregado:
        return 'Entregado';
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();
    final actionData = _getActionButtonData();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isSelected
            ? BorderSide(color: statusColor, width: 2) // Resaltar item seleccionado
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Encabezado: Mesa, Estado, Tiempo ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      order.table,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Badge de estado
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        _getStatusText(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                // Tiempo
                Row(
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      color: statusColor,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${order.timeInMinutes} min',
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Pedido #${order.orderId}',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
            const Divider(height: 20, thickness: 1),

            // --- Lista de Ítems del Pedido ---
            ...order.items.asMap().entries.map((entry) {
              final index = entry.key + 1;
              final item = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Círculo con el número de cantidad
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: statusColor, // Usar el color del estado
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '$index',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Nombre del plato y notas
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${item.quantity}x ${item.menuItem.name}',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          if (item.notes != null && item.notes!.isNotEmpty)
                            Row(
                              children: [
                                const Icon(
                                  Icons.menu_book, // Icono para notas (ej. término de cocción)
                                  color: Colors.redAccent,
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  item.notes!,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.redAccent,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),

            const SizedBox(height: 12),
            // --- Footer: Mesero y Botón de Acción ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Mesero: ${order.waiter}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
                // Botón de Acción
                if (order.status != OrderStatus.entregado)
                  ElevatedButton(
                    onPressed: onActionPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: actionData['color'] as Color,
                      foregroundColor: actionData['textColor'] as Color,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      actionData['text'] as String,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}