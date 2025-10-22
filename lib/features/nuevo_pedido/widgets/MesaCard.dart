import 'package:flutter/material.dart';

class MesaCard extends StatelessWidget {
  final int numero;
  final bool activa;
  final int count;
  final VoidCallback? onTap;

  const MesaCard({
    super.key,
    required this.numero,
    this.activa = false,
    this.count = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // 👈 hace que la card sea interactiva
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          color: activa ? Colors.orange.shade50 : Colors.white,
          border: Border.all(
            color: activa ? Colors.orange : Colors.grey.shade300,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            if (activa)
              BoxShadow(
                color: Colors.orange.withOpacity(0.3),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
          ],
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                'Mesa $numero',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: activa ? Colors.orange : Colors.black87,
                ),
              ),
            ),
            if (count > 0)
              Positioned(
                right: 8,
                top: 8,
                child: CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.red,
                  child: Text(
                    '$count',
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
