/// Modelo para um ambiente (ex: Casa, Trabalho, Casa de Praia)
class Environment {
  final String id;
  final String userId;
  final String name;
  final String? location;
  final int order;

  Environment({
    required this.id,
    required this.userId,
    required this.name,
    this.location,
    this.order = 0,
  });

  factory Environment.fromMap(String id, Map<String, dynamic> map) {
    return Environment(
      id: id,
      userId: map['user_id'] as String? ?? '',
      name: map['name'] as String? ?? 'Ambiente',
      location: map['location'] as String?,
      order: (map['order'] as int?) ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'name': name,
      'location': location,
      'order': order,
    };
  }

  Environment copyWith({
    String? id,
    String? userId,
    String? name,
    String? location,
    int? order,
  }) {
    return Environment(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      location: location ?? this.location,
      order: order ?? this.order,
    );
  }
}
