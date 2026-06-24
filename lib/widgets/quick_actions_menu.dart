import 'package:flutter/material.dart';

/// Menu flutuante de ações rápidas (Adicionar dispositivo, Escanear QR)
class QuickActionsMenu extends StatelessWidget {
  final VoidCallback onAddDevice;
  final VoidCallback onScanQR;

  const QuickActionsMenu({
    super.key,
    required this.onAddDevice,
    required this.onScanQR,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Opção 1: Escanear QR
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
            onScanQR();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.qr_code_scanner,
                  color: Colors.blue[600],
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  'Escanear QR',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.blue[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Opção 2: Adicionar dispositivo
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
            onAddDevice();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.add_circle_outline,
                  color: Colors.green[600],
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  'Adicionar Dispositivo',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.green[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Mostra o menu em um bottom sheet
  static void show(
    BuildContext context, {
    required VoidCallback onAddDevice,
    required VoidCallback onScanQR,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: QuickActionsMenu(
          onAddDevice: onAddDevice,
          onScanQR: onScanQR,
        ),
      ),
    );
  }
}
