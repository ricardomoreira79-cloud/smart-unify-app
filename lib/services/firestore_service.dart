import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/device_model.dart';
import '../models/scene_model.dart';
import '../models/environment_model.dart';

/// Serviço para interagir com o Firestore
class FirestoreService {
  static final FirestoreService _instance = FirestoreService._internal();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  factory FirestoreService() {
    return _instance;
  }

  FirestoreService._internal();

  /// Stream de dispositivos do usuário
  Stream<List<Device>> getDevicesStream(String userId) {
    return _firestore
        .collection('devices')
        .where('user_id', isEqualTo: userId)
        .orderBy('is_favorite', descending: true)
        .orderBy('name')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Device.fromMap(doc.id, doc.data()))
              .toList();
        });
  }

  /// Stream de dispositivos filtrados por cômodo
  Stream<List<Device>> getDevicesByRoomStream(String userId, String room) {
    if (room == 'Favoritos') {
      return _firestore
          .collection('devices')
          .where('user_id', isEqualTo: userId)
          .where('is_favorite', isEqualTo: true)
          .orderBy('name')
          .snapshots()
          .map((snapshot) {
            return snapshot.docs
                .map((doc) => Device.fromMap(doc.id, doc.data()))
                .toList();
          });
    }

    return _firestore
        .collection('devices')
        .where('user_id', isEqualTo: userId)
        .where('room', isEqualTo: room)
        .orderBy('is_favorite', descending: true)
        .orderBy('name')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Device.fromMap(doc.id, doc.data()))
              .toList();
        });
  }

  /// Alterna o status de um dispositivo
  Future<void> toggleDeviceStatus(String deviceId, bool currentStatus) async {
    try {
      await _firestore.collection('devices').doc(deviceId).update({
        'status': !currentStatus,
      });
    } catch (e) {
      throw Exception('Erro ao atualizar status do dispositivo: $e');
    }
  }

  /// Atualiza o status de um canal específico
  Future<void> toggleChannelStatus(
    String deviceId,
    String channelId,
    bool currentStatus,
  ) async {
    try {
      final doc = await _firestore.collection('devices').doc(deviceId).get();
      final channels = doc.data()?['channels'] as List<dynamic>? ?? [];
      
      final updatedChannels = channels.map((ch) {
        if (ch['id'] == channelId) {
          return {...ch as Map, 'status': !currentStatus};
        }
        return ch;
      }).toList();

      await _firestore.collection('devices').doc(deviceId).update({
        'channels': updatedChannels,
      });
    } catch (e) {
      throw Exception('Erro ao atualizar canal: $e');
    }
  }

  /// Alterna se um dispositivo é favorito
  Future<void> toggleFavorite(String deviceId, bool currentFavorite) async {
    try {
      await _firestore.collection('devices').doc(deviceId).update({
        'is_favorite': !currentFavorite,
      });
    } catch (e) {
      throw Exception('Erro ao atualizar favorito: $e');
    }
  }

  /// Retorna os cômodos únicos de um usuário
  Future<List<String>> getRooms(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('devices')
          .where('user_id', isEqualTo: userId)
          .get();

      final rooms = <String>{'Favoritos'};
      
      for (var doc in snapshot.docs) {
        final room = doc.data()['room'] as String?;
        if (room != null && room.isNotEmpty) {
          rooms.add(room);
        }
      }

      return rooms.toList();
    } catch (e) {
      throw Exception('Erro ao buscar cômodos: $e');
    }
  }

  /// Stream de ambientes (environments) do usuário
  Stream<List<Environment>> getEnvironmentsStream(String userId) {
    return _firestore
        .collection('environments')
        .where('user_id', isEqualTo: userId)
        .orderBy('order')
        .snapshots()
        .map((snap) => snap.docs.map((d) => Environment.fromMap(d.id, Map<String, dynamic>.from(d.data() as Map? ?? {}))).toList());
  }

  /// Busca ambientes (não-stream)
  Future<List<Environment>> getEnvironments(String userId) async {
    try {
      final snap = await _firestore.collection('environments').where('user_id', isEqualTo: userId).get();
      return snap.docs.map((d) => Environment.fromMap(d.id, Map<String, dynamic>.from(d.data() as Map? ?? {}))).toList();
    } catch (e) {
      throw Exception('Erro ao buscar ambientes: $e');
    }
  }

  /// Stream de cenas (scenes)
  Stream<List<Scene>> getScenesStream(String userId, {String? environmentId}) {
    Query query = _firestore.collection('scenes').where('user_id', isEqualTo: userId);
    if (environmentId != null) {
      query = query.where('environment_id', isEqualTo: environmentId);
    }
    return query.snapshots().map((snap) => snap.docs.map((d) => Scene.fromMap(d.id, Map<String, dynamic>.from(d.data() as Map? ?? {}))).toList());
  }

  /// Cria uma cena
  Future<String> createScene(String userId, Scene scene) async {
    try {
      final ref = await _firestore.collection('scenes').add(scene.toMap());
      return ref.id;
    } catch (e) {
      throw Exception('Erro ao criar cena: $e');
    }
  }

  /// Atualiza uma cena
  Future<void> updateScene(String userId, Scene scene) async {
    try {
      await _firestore.collection('scenes').doc(scene.id).set(scene.toMap());
    } catch (e) {
      throw Exception('Erro ao atualizar cena: $e');
    }
  }

  /// Deleta uma cena
  Future<void> deleteScene(String userId, String sceneId) async {
    try {
      await _firestore.collection('scenes').doc(sceneId).delete();
    } catch (e) {
      throw Exception('Erro ao deletar cena: $e');
    }
  }

  /// Executa uma cena localmente (cliente). Usa profundidade máxima para evitar loops.
  Future<void> executeScene(String userId, Scene scene, {int maxDepth = 5, int depth = 0}) async {
    if (depth > maxDepth) return;

    for (final action in scene.actions) {
      try {
        if (action.type == 'device_action') {
          final deviceId = action.payload['deviceId'] as String?;
          final channelId = action.payload['channelId'] as String?;
          if (deviceId != null && channelId != null) {
            // switch channel
            // read current status
            final doc = await _firestore.collection('devices').doc(deviceId).get();
            final channels = doc.data()?['channels'] as List<dynamic>? ?? [];
            final ch = channels.firstWhere((c) => c['id'] == channelId, orElse: () => null);
            if (ch != null) {
              final current = ch['status'] as bool? ?? false;
              await toggleChannelStatus(deviceId, channelId, current);
            }
          } else if (deviceId != null) {
            final doc = await _firestore.collection('devices').doc(deviceId).get();
            final current = doc.data()?['status'] as bool? ?? false;
            await toggleDeviceStatus(deviceId, current);
          }
        } else if (action.type == 'delay') {
          final ms = action.payload['ms'] as int? ?? 0;
          await Future.delayed(Duration(milliseconds: ms));
        } else if (action.type == 'scene_call') {
          final calledId = action.payload['sceneId'] as String?;
          if (calledId != null) {
            final snap = await _firestore.collection('scenes').doc(calledId).get();
            if (snap.exists) {
              final called = Scene.fromMap(snap.id, snap.data() ?? {});
              await executeScene(userId, called, maxDepth: maxDepth, depth: depth + 1);
            }
          }
        }
      } catch (e) {
        // swallow per-action errors but continue
      }
    }
  }

  /// Busca dados da casa do usuário
  Future<House?> getHouse(String userId) async {
    try {
      final snapshot = await _firestore.collection('houses').doc(userId).get();
      if (snapshot.exists) {
        return House.fromMap(snapshot.data() ?? {});
      }
      return null;
    } catch (e) {
      throw Exception('Erro ao buscar dados da casa: $e');
    }
  }

  /// Stream de dados da casa em tempo real
  Stream<House?> getHouseStream(String userId) {
    return _firestore
        .collection('houses')
        .doc(userId)
        .snapshots()
        .map((snapshot) {
          if (snapshot.exists) {
            return House.fromMap(snapshot.data() ?? {});
          }
          return null;
        });
  }

  /// Cria ou atualiza dados da casa
  Future<void> updateHouse(String userId, House house) async {
    try {
      await _firestore.collection('houses').doc(userId).set({
        'user_id': userId,
        'name': house.name,
        'location': house.location,
      });
    } catch (e) {
      throw Exception('Erro ao atualizar dados da casa: $e');
    }
  }
}
