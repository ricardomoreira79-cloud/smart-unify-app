/// Modelo de dados para um canal de switch (usado em dispositivos com múltiplos switches)
class DeviceChannel {
  final String id;
  final String name;
  final bool status;

  DeviceChannel({
    required this.id,
    required this.name,
    required this.status,
  });

  factory DeviceChannel.fromMap(Map<String, dynamic> map) {
    return DeviceChannel(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? 'Canal',
      status: map['status'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'status': status,
    };
  }
}

/// Modelo de dados para um dispositivo
class Device {
  final String id;
  final String userId;
  final String name;
  final String type; // 'climate', 'simple', 'switch_group', etc
  final String room;
  final String? environmentId;
  final String location;
  final bool status;
  final bool isOnline;
  final bool isFavorite;
  
  // Dados específicos para clima
  final double? temperature;
  final double? humidity;
  final double? pm25;
  final String? weatherType;
  
  // Dados específicos para switch group
  final List<DeviceChannel>? channels;

  Device({
    required this.id,
    required this.userId,
    required this.name,
    required this.type,
    required this.room,
    this.environmentId,
    required this.location,
    required this.status,
    required this.isOnline,
    required this.isFavorite,
    this.temperature,
    this.humidity,
    this.pm25,
    this.weatherType,
    this.channels,
  });

  factory Device.fromMap(String docId, Map<String, dynamic> map) {
    return Device(
      id: docId,
      userId: map['user_id'] as String? ?? '',
      name: map['name'] as String? ?? 'Dispositivo',
      type: map['type'] as String? ?? 'simple',
      room: map['room'] as String? ?? 'Sem cômodo',
      environmentId: map['environment_id'] as String?,
      location: map['location'] as String? ?? '',
      status: map['status'] as bool? ?? false,
      isOnline: map['is_online'] as bool? ?? true,
      isFavorite: map['is_favorite'] as bool? ?? false,
      temperature: (map['temperature'] as num?)?.toDouble(),
      humidity: (map['humidity'] as num?)?.toDouble(),
      pm25: (map['pm25'] as num?)?.toDouble(),
      weatherType: map['weather_type'] as String?,
      channels: (map['channels'] as List<dynamic>?)
          ?.cast<Map<String, dynamic>>()
          .map((ch) => DeviceChannel.fromMap(ch))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'name': name,
      'type': type,
      'room': room,
      'environment_id': environmentId,
      'location': location,
      'status': status,
      'is_online': isOnline,
      'is_favorite': isFavorite,
      'temperature': temperature,
      'humidity': humidity,
      'pm25': pm25,
      'weather_type': weatherType,
      'channels': channels?.map((ch) => ch.toMap()).toList(),
    };
  }

  /// Cria uma cópia do dispositivo com campos atualizados
  Device copyWith({
    String? id,
    String? userId,
    String? name,
    String? type,
    String? room,
    String? environmentId,
    String? location,
    bool? status,
    bool? isOnline,
    bool? isFavorite,
    double? temperature,
    double? humidity,
    double? pm25,
    String? weatherType,
    List<DeviceChannel>? channels,
  }) {
    return Device(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      type: type ?? this.type,
      room: room ?? this.room,
      environmentId: environmentId ?? this.environmentId,
      location: location ?? this.location,
      status: status ?? this.status,
      isOnline: isOnline ?? this.isOnline,
      isFavorite: isFavorite ?? this.isFavorite,
      temperature: temperature ?? this.temperature,
      humidity: humidity ?? this.humidity,
      pm25: pm25 ?? this.pm25,
      weatherType: weatherType ?? this.weatherType,
      channels: channels ?? this.channels,
    );
  }
}

/// Modelo para dados da casa/usuário
class House {
  final String userId;
  final String name;
  final String location;

  House({
    required this.userId,
    required this.name,
    required this.location,
  });

  factory House.fromMap(Map<String, dynamic> map) {
    return House(
      userId: map['user_id'] as String? ?? '',
      name: map['name'] as String? ?? 'Minha Casa',
      location: map['location'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'name': name,
      'location': location,
    };
  }
}
