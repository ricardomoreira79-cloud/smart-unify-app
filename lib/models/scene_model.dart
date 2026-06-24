/// Modelo para ação dentro de uma cena
class SceneAction {
  final String type; // 'device_action' | 'scene_call' | 'delay'
  final Map<String, dynamic> payload;

  SceneAction({required this.type, required this.payload});

  factory SceneAction.fromMap(Map<String, dynamic> map) {
    return SceneAction(
      type: map['type'] as String? ?? 'device_action',
      payload: Map<String, dynamic>.from(map['payload'] as Map? ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'payload': payload,
    };
  }
}

/// Modelo para uma cena (sequence de ações)
class Scene {
  final String id;
  final String userId;
  final String name;
  final String? environmentId;
  final bool isGlobal;
  final List<SceneAction> actions;

  Scene({
    required this.id,
    required this.userId,
    required this.name,
    this.environmentId,
    this.isGlobal = false,
    this.actions = const [],
  });

  factory Scene.fromMap(String id, Map<String, dynamic> map) {
    final actionsRaw = (map['actions'] as List<dynamic>?) ?? [];
    return Scene(
      id: id,
      userId: map['user_id'] as String? ?? '',
      name: map['name'] as String? ?? 'Cena',
      environmentId: map['environment_id'] as String?,
      isGlobal: map['is_global'] as bool? ?? false,
      actions: actionsRaw.map((a) => SceneAction.fromMap(a as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'name': name,
      'environment_id': environmentId,
      'is_global': isGlobal,
      'actions': actions.map((a) => a.toMap()).toList(),
    };
  }

  Scene copyWith({
    String? id,
    String? userId,
    String? name,
    String? environmentId,
    bool? isGlobal,
    List<SceneAction>? actions,
  }) {
    return Scene(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      environmentId: environmentId ?? this.environmentId,
      isGlobal: isGlobal ?? this.isGlobal,
      actions: actions ?? this.actions,
    );
  }
}
