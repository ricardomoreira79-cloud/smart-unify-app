import 'package:flutter/material.dart';

/// Cartão de dispositivo simples com estado online/offline
/// Layout 1x1 com nome, localização e status
class SimpleDeviceCard extends StatelessWidget {
  final String deviceName;
  final String location;
  final bool isOnline;
  final bool status;
  final IconData icon;
  final VoidCallback onTap;
  final VoidCallback onToggle;
  final bool isFavorite;
  final VoidCallback? onFavoriteTap;

  const SimpleDeviceCard({
    super.key,
    required this.deviceName,
    required this.location,
    required this.isOnline,
    required this.status,
    required this.icon,
    required this.onTap,
    required this.onToggle,
    this.isFavorite = false,
    this.onFavoriteTap,
  });

  /// Retorna a cor baseada no status do dispositivo
  Color _getStatusColor() {
    if (!isOnline) {
      return Colors.grey[400]!;
    }
    return status ? Colors.blue[400]! : Colors.grey[300]!;
  }

  /// Retorna o texto de status
  String _getStatusText() {
    if (!isOnline) {
      return 'Offline';
    }
    return status ? 'Ativo' : 'Inativo';
  }

  /// Retorna a cor da tag de status
  Color _getStatusTagColor() {
    if (!isOnline) {
      return Colors.grey[100]!;
    }
    return status ? Colors.blue[50]! : Colors.grey[100]!;
  }

  Color _getStatusTagTextColor() {
    if (!isOnline) {
      return Colors.grey[600]!;
    }
    return status ? Colors.blue[700]! : Colors.grey[600]!;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey[200]!,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Conteúdo principal
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header com ícone e botão favorito
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _getStatusColor().withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          icon,
                          size: 28,
                          color: _getStatusColor(),
                        ),
                      ),
                      GestureDetector(
                        onTap: onFavoriteTap,
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.grey[400],
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  // Nome e localização
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        deviceName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  // Tag de status
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusTagColor(),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _getStatusText(),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: _getStatusTagTextColor(),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Botão flutuante de toggle no canto inferior direito
            if (isOnline)
              Positioned(
                right: 8,
                bottom: 8,
                child: GestureDetector(
                  onTap: onToggle,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: _getStatusColor(),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      status ? Icons.power_settings_new : Icons.power_settings_new,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
