import 'package:flutter/material.dart';
import 'package:lab_04/features/menu/screens/menu_screen.dart';
import 'package:lab_04/features/nuevo_pedido/widgets/mesaCard.dart';
import 'package:lab_04/features/nuevo_pedido/widgets/pedidoCard.dart';

class PedidosActivosScreen extends StatefulWidget {
  const PedidosActivosScreen({super.key});

  @override
  State<PedidosActivosScreen> createState() => _PedidosActivosScreenState();
}

class _PedidosActivosScreenState extends State<PedidosActivosScreen> {
  List<Map<String, dynamic>> mesas = [
    {'numero': 1, 'activa': false},
    {'numero': 2, 'activa': false},
    {'numero': 3, 'activa': true, 'count': 1},
    {'numero': 4, 'activa': false},
    {'numero': 5, 'activa': true, 'count': 1},
    {'numero': 6, 'activa': false},
    {'numero': 7, 'activa': false},
    {'numero': 8, 'activa': true, 'count': 1},
    {'numero': 9, 'activa': false},
    {'numero': 10, 'activa': false},
    {'numero': 11, 'activa': false},
    {'numero': 12, 'activa': false},
  ];

  final pedidos = [
    {
      'mesa': 5,
      'estado': 'En Preparación',
      'color': Colors.purple,
      'tiempo': '15 min',
      'precio': 47.97,
      'cliente': 'María',
    },
    {
      'mesa': 3,
      'estado': 'Pendiente',
      'color': Colors.lightGreen,
      'tiempo': '5 min',
      'precio': 30.97,
      'cliente': 'Carlos',
    },
    {
      'mesa': 8,
      'estado': 'Listo',
      'color': Colors.green,
      'tiempo': '25 min',
      'precio': 36.97,
      'cliente': 'María',
    },
  ];

  void toggleMesa(int index) {
    setState(() {
      mesas[index]['activa'] = !(mesas[index]['activa'] as bool);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedidos Activos'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Sección de Mesas
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: mesas.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.3,
              ),
              itemBuilder: (context, index) {
                final mesa = mesas[index];
                return MesaCard(
                  numero: mesa['numero'] as int,
                  activa: mesa['activa'] as bool,
                  count: (mesa['count'] as int?) ?? 0,
                  onTap: () => toggleMesa(index),
                );
              },
            ),

            const SizedBox(height: 24),

            // 🔹 Sección de Pedidos Recientes
            const Text(
              "Pedidos Recientes",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Column(
              children: pedidos.map((pedido) {
                return PedidoCard(
                  mesa: pedido['mesa'] as int,
                  estado: pedido['estado'] as String,
                  colorEstado: pedido['color'] as Color,
                  tiempo: pedido['tiempo'] as String,
                  precio: pedido['precio'] as double,
                  cliente: pedido['cliente'] as String,
                );
              }).toList(),
            ),
          ],
        ),
      ),

      // 🔹 Botón de Nuevo Pedido
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MenuScreen()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepOrange,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            "+ Nuevo Pedido",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
