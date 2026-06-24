import 'package:flutter/material.dart';

/// Representa um canal de switch individual
class SwitchChannel {
  final String id;
  final String name;
  final bool status;
  final IconData? icon;

  SwitchChannel({
    required this.id,
    required this.name,
    required this.status,
    this.icon,
  });
}

/// Cartão de múltiplos switches (ex: W603)
/// Exibe um nome do dispositivo, botão geral de energia
/// e uma fileira de switches individuais com ícones coloridos
class SwitchGroupCard extends StatelessWidget {
  final String deviceName;
  final String location;
  final List<SwitchChannel> channels;
  final bool isOnline;
  final bool masterStatus;
  final Function(String channelId, bool newStatus) onChannelToggle;
  final VoidCallback onMasterToggle;
  final VoidCallback onTap;
  final bool isFavorite;
  final VoidCallback? onFavoriteTap;

  const SwitchGroupCard({
    super.key,
    required this.deviceName,
    required this.location,
    required this.channels,
    required this.isOnline,
    required this.masterStatus,
    required this.onChannelToggle,
    required this.onMasterToggle,
    required this.onTap,
    this.isFavorite = false,
    this.onFavoriteTap,
  });

  Color _getStatusColor(bool status) {
    return status ? Colors.blue[600]! : Colors.grey[400]!;
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Nome do dispositivo + Botão favorito
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          deviceName,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          location,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
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
              const SizedBox(height: 12),
              // Divisor
              Divider(
                color: Colors.grey[200],
                height: 1,
              ),
              const SizedBox(height: 12),
              // Seção de botão geral + status online
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Energia',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.grey[600],
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: isOnline
                              ? Colors.green[50]
                              : Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            isOnline ? 'Online' : 'Offline',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: isOnline
                                ? Colors.green[700]
                                : Colors.grey[600],
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Botão de master toggle
                  if (isOnline)
                    GestureDetector(
                      onTap: onMasterToggle,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(masterStatus),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              masterStatus
                                ? Icons.power_settings_new
                                : Icons.power_settings_new,
                              size: 18,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              masterStatus ? 'Ligar' : 'Desligar',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Desconectado',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 14),
              // Divisor
              Divider(
                color: Colors.grey[200],
                height: 1,
              ),
              const SizedBox(height: 12),
              // Switches individuais
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    channels.length,
                    (index) {
                      final channel = channels[index];
                      return Padding(
                        padding: EdgeInsets.only(
                          right: index < channels.length - 1 ? 12 : 0,
                        ),
                        child: _buildSwitchChannel(
                          context,
                          channel,
                          isOnline,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Constrói um switch individual
  Widget _buildSwitchChannel(
    BuildContext context,
    SwitchChannel channel,
    bool isOnline,
  ) {
    return GestureDetector(
      onTap: isOnline
        ? () => onChannelToggle(channel.id, !channel.status)
        : null,
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: channel.status
            ? _getStatusColor(channel.status).withOpacity(0.1)
            : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: channel.status
              ? _getStatusColor(channel.status).withOpacity(0.3)
              : Colors.grey[300]!,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              channel.icon ?? Icons.power_settings_new,
              size: 28,
              color: channel.status && isOnline
                ? _getStatusColor(channel.status)
                : Colors.grey[400],
            ),
            const SizedBox(height: 6),
            Text(
              channel.name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Colors.grey[700],
                fontSize: 9,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
