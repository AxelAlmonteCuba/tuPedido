import 'package:flutter/material.dart';
import '../models/kitchen_order.dart'; 
import '../widgets/kitchen_panel_item.dart'; 

class KitchenPanelScreen extends StatefulWidget {
  const KitchenPanelScreen({Key? key}) : super(key: key);

  @override
  State<KitchenPanelScreen> createState() => _KitchenPanelScreenState();
}

class _KitchenPanelScreenState extends State<KitchenPanelScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<KitchenOrder> _kitchenOrders;
  KitchenOrder? _selectedOrder; 

  @override
  void initState() {
    super.initState();
    // Inicializar con datos de ejemplo
    _kitchenOrders = dummyKitchenOrders;
    
    // Inicializar TabController
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);

    // Inicialmente, selecciona el primer pedido Pendiente
    _selectedOrder = _getOrdersByStatus(OrderStatus.pendiente).isNotEmpty
        ? _getOrdersByStatus(OrderStatus.pendiente).first
        : null;
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  // --- Manejo de la lógica del estado (simulado) ---

  // Lógica para actualizar el item seleccionado al cambiar de tab
  void _handleTabSelection() {
    if (_tabController.indexIsChanging) return;
    
    // Obtener la lista de la nueva pestaña
    final currentStatus = _getStatusForTabIndex(_tabController.index);
    final orders = _getOrdersByStatus(currentStatus);

    // Seleccionar el primer item del nuevo tab
    setState(() {
      _selectedOrder = orders.isNotEmpty ? orders.first : null;
    });
  }

  // Obtener la lista de órdenes por estado
  List<KitchenOrder> _getOrdersByStatus(OrderStatus status) {
    return _kitchenOrders.where((order) => order.status == status).toList();
  }

  // Obtener el estado correspondiente al índice del tab
  OrderStatus _getStatusForTabIndex(int index) {
    switch (index) {
      case 0:
        return OrderStatus.pendiente;
      case 1:
        return OrderStatus.enPreparacion;
      case 2:
        return OrderStatus.listo;
      default:
        return OrderStatus.pendiente;
    }
  }

  // Lógica para Comenzar, Marcar Listo, Entregado
  void _handleOrderAction(String orderId) {
    setState(() {
      final orderIndex = _kitchenOrders.indexWhere((o) => o.orderId == orderId);
      if (orderIndex != -1) {
        final currentOrder = _kitchenOrders[orderIndex];
        KitchenOrder updatedOrder;

        switch (currentOrder.status) {
          case OrderStatus.pendiente:
            // Pasa de Pendiente a En Preparación
            updatedOrder = KitchenOrder(
              orderId: currentOrder.orderId,
              table: currentOrder.table,
              waiter: currentOrder.waiter,
              status: OrderStatus.enPreparacion,
              items: currentOrder.items,
              timeInMinutes: 0, // Reiniciar tiempo
            );
            // Cambia el tab a "En Preparación"
            _tabController.animateTo(1);
            break;
          case OrderStatus.enPreparacion:
            // Pasa de En Preparación a Listo
            updatedOrder = KitchenOrder(
              orderId: currentOrder.orderId,
              table: currentOrder.table,
              waiter: currentOrder.waiter,
              status: OrderStatus.listo,
              items: currentOrder.items,
              timeInMinutes: 0, // Reiniciar tiempo
            );
            // Cambia el tab a "Listos"
            _tabController.animateTo(2);
            break;
          case OrderStatus.listo:
            // Pasa de Listo a Entregado (se elimina de la vista principal)
            _kitchenOrders.removeAt(orderIndex);
            // Selecciona un nuevo item
            _selectedOrder = _getOrdersByStatus(OrderStatus.listo).isNotEmpty
                ? _getOrdersByStatus(OrderStatus.listo).first
                : null;
            return; // No se actualiza, se elimina
          default:
            return;
        }

        // Reemplazar la orden actualizada
        _kitchenOrders[orderIndex] = updatedOrder;
        _selectedOrder = updatedOrder; // Seleccionar la orden recién actualizada
      }
    });
  }

  // --- Widgets del diseño ---

  // Tarjeta de resumen de estado (Pendientes, Preparando, Listos)
  Widget _buildStatusCard(
      String title, OrderStatus status, Color backgroundColor) {
    final count = _getOrdersByStatus(status).length;
    final isSelected = _getStatusForTabIndex(_tabController.index) == status;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          _tabController.animateTo(status == OrderStatus.pendiente
              ? 0
              : status == OrderStatus.enPreparacion
                  ? 1
                  : 2);
        },
        child: Container(
          height: 80,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: isSelected
                ? Border.all(color: Colors.black, width: 2.0)
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$count',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Pestañas de la lista (Pendientes, En Prep., Listos)
  Widget _buildTabBar() {
    final pendingCount = _getOrdersByStatus(OrderStatus.pendiente).length;
    final prepCount = _getOrdersByStatus(OrderStatus.enPreparacion).length;
    final readyCount = _getOrdersByStatus(OrderStatus.listo).length;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        labelColor: Colors.black87,
        unselectedLabelColor: Colors.grey[600],
        tabs: [
          Tab(text: 'Pendientes ($pendingCount)'),
          Tab(text: 'En Prep. ($prepCount)'),
          Tab(text: 'Listos ($readyCount)'),
        ],
      ),
    );
  }

  // Cuerpo de la lista de órdenes
  Widget _buildOrderList(OrderStatus status) {
    final orders = _getOrdersByStatus(status);

    if (orders.isEmpty) {
      return Center(
        child: Text(
          'No hay pedidos en estado ${_getStatusText(status).toLowerCase()}.',
          style: TextStyle(color: Colors.grey[600]),
        ),
      );
    }

    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedOrder = order;
            });
          },
          child: KitchenPanelItem(
            order: order,
            isSelected: _selectedOrder?.orderId == order.orderId,
            onActionPressed: () => _handleOrderAction(order.orderId),
          ),
        );
      },
    );
  }
  
  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.pendiente:
        return 'Pendiente';
      case OrderStatus.enPreparacion:
        return 'En Preparación';
      case OrderStatus.listo:
        return 'Listo';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.restaurant, color: Color(0xFFFF5722)),
            const SizedBox(width: 8),
            const Text(
              'Panel de Cocina',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 1. Tarjetas de Resumen
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(
              left: 12,
              right: 12,
              top: 8,
              bottom: 4,
            ),
            child: Row(
              children: [
                _buildStatusCard(
                  'Pendientes',
                  OrderStatus.pendiente,
                  const Color(0xFFFFFDE7), 
                ),
                _buildStatusCard(
                  'Preparando',
                  OrderStatus.enPreparacion,
                  const Color(0xFFE3F2FD), 
                ),
                _buildStatusCard(
                  'Listos',
                  OrderStatus.listo,
                  const Color(0xFFE8F5E9), 
                ),
              ],
            ),
          ),
          
          // 2. Tab Bar
          Container(
            color: Colors.white,
            child: _buildTabBar(),
          ),

          // 3. Lista de Órdenes
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOrderList(OrderStatus.pendiente),
                _buildOrderList(OrderStatus.enPreparacion),
                _buildOrderList(OrderStatus.listo),
              ],
            ),
          ),
        ],
      ),
    );
  }
}