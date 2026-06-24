import 'package:flutter/material.dart';

/// Cartão de clima com temperatura grande, umidade e PM2.5
/// Otimizado para ocupar 2x1 no grid
class ClimateCard extends StatelessWidget {
  final double temperature;
  final double humidity;
  final double pm25;
  final String location;
  final String weatherType; // 'sunny', 'cloudy', 'rainy', etc
  final VoidCallback onTap;

  const ClimateCard({
    super.key,
    required this.temperature,
    required this.humidity,
    required this.pm25,
    required this.location,
    this.weatherType = 'sunny',
    required this.onTap,
  });

  /// Retorna o ícone de clima apropriado
  IconData _getWeatherIcon() {
    switch (weatherType.toLowerCase()) {
      case 'cloudy':
        return Icons.cloud;
      case 'rainy':
        return Icons.cloud_queue;
      case 'stormy':
        return Icons.flash_on;
      case 'sunny':
      default:
        return Icons.wb_sunny;
    }
  }

  /// Retorna a cor de fundo baseada no tipo de clima
  Color _getBackgroundGradientStart() {
    switch (weatherType.toLowerCase()) {
      case 'cloudy':
        return Colors.grey[400]!;
      case 'rainy':
        return Colors.blue[300]!;
      case 'stormy':
        return Colors.purple[300]!;
      case 'sunny':
      default:
        return Colors.orange[300]!;
    }
  }

  Color _getBackgroundGradientEnd() {
    switch (weatherType.toLowerCase()) {
      case 'cloudy':
        return Colors.grey[600]!;
      case 'rainy':
        return Colors.blue[600]!;
      case 'stormy':
        return Colors.purple[600]!;
      case 'sunny':
      default:
        return Colors.orange[600]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _getBackgroundGradientStart(),
              _getBackgroundGradientEnd(),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Ícone de fundo grande
            Positioned(
              right: -30,
              top: -30,
              child: Icon(
                _getWeatherIcon(),
                size: 180,
                color: Colors.white.withOpacity(0.15),
              ),
            ),
            // Conteúdo principal
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Header com localização e ícone
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Clima',
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            location,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        _getWeatherIcon(),
                        color: Colors.white,
                        size: 32,
                      ),
                    ],
                  ),
                  // Temperatura grande
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${temperature.toStringAsFixed(1)}°',
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 56,
                        ),
                      ),
                      Text(
                        'Temperatura',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  // Informações adicionais (Umidade e PM2.5)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              'Umidade',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 10,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${humidity.toStringAsFixed(0)}%',
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 30,
                          width: 1,
                          color: Colors.white.withOpacity(0.3),
                        ),
                        Column(
                          children: [
                            Text(
                              'PM2.5',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 10,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${pm25.toStringAsFixed(1)}',
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
