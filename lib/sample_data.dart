import 'package:cloud_firestore/cloud_firestore.dart';

/// Script para popular Firestore com dados de exemplo
/// Execute uma vez para criar dispositivos de teste

class FirestoreSampleData {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Popula o Firestore com dados de exemplo
  /// Pass o userId do usuário logado
  static Future<void> populateSampleData(String userId) async {
    try {
      // 1. Criar house document
      await _firestore.collection('houses').doc(userId).set({
        'user_id': userId,
        'name': 'Casa',
        'location': 'São Paulo, SP',
      });

      // 2. Criar dispositivo de clima
      await _firestore.collection('devices').add({
        'user_id': userId,
        'name': 'Sensor Sala',
        'type': 'climate',
        'room': 'Sala de Estar',
        'location': 'Parede central',
        'status': true,
        'is_online': true,
        'is_favorite': true,
        'temperature': 26.5,
        'humidity': 62.0,
        'pm25': 32.0,
        'weather_type': 'sunny',
      });

      // 3. Criar dispositivo simples - Portão
      await _firestore.collection('devices').add({
        'user_id': userId,
        'name': 'Portão Casa',
        'type': 'simple',
        'room': 'Área frente',
        'location': 'Entrada principal',
        'status': false,
        'is_online': true,
        'is_favorite': true,
      });

      // 4. Criar dispositivo simples - Luz Quarto
      await _firestore.collection('devices').add({
        'user_id': userId,
        'name': 'Luz Quarto',
        'type': 'simple',
        'room': 'Quarto',
        'location': 'Teto',
        'status': false,
        'is_online': true,
        'is_favorite': false,
      });

      // 5. Criar dispositivo simples - Tomada Sala
      await _firestore.collection('devices').add({
        'user_id': userId,
        'name': 'Tomada Sala',
        'type': 'simple',
        'room': 'Sala de Estar',
        'location': 'Parede direita',
        'status': true,
        'is_online': true,
        'is_favorite': false,
      });

      // 6. Criar dispositivo switch group - Painel Principal
      await _firestore.collection('devices').add({
        'user_id': userId,
        'name': 'Painel Principal',
        'type': 'switch_group',
        'room': 'Entrada',
        'location': 'Hall de entrada',
        'status': true,
        'is_online': true,
        'is_favorite': true,
        'channels': [
          {
            'id': 'ch1',
            'name': 'Sala',
            'status': true,
          },
          {
            'id': 'ch2',
            'name': 'Quarto',
            'status': false,
          },
          {
            'id': 'ch3',
            'name': 'Cozinha',
            'status': true,
          },
        ],
      });

      // 7. Criar dispositivo simples - Câmera
      await _firestore.collection('devices').add({
        'user_id': userId,
        'name': 'Câmera Entrada',
        'type': 'simple',
        'room': 'Área frente',
        'location': 'Acima da porta',
        'status': true,
        'is_online': true,
        'is_favorite': false,
      });

      // 8. Criar dispositivo simples - Sensor de Fumaça
      await _firestore.collection('devices').add({
        'user_id': userId,
        'name': 'Detector de Fumaça',
        'type': 'simple',
        'room': 'Cozinha',
        'location': 'Teto',
        'status': true,
        'is_online': true,
        'is_favorite': false,
      });

      // 9. Criar dispositivo simples - Ar Condicionado
      await _firestore.collection('devices').add({
        'user_id': userId,
        'name': 'Ar Condicionado',
        'type': 'simple',
        'room': 'Quarto',
        'location': 'Janela',
        'status': false,
        'is_online': true,
        'is_favorite': true,
      });

      // 10. Criar dispositivo simples - Fechadura
      await _firestore.collection('devices').add({
        'user_id': userId,
        'name': 'Fechadura Inteligente',
        'type': 'simple',
        'room': 'Entrada',
        'location': 'Porta principal',
        'status': false,
        'is_online': true,
        'is_favorite': true,
      });

      // 11. Criar dispositivo simples - Luz Cozinha
      await _firestore.collection('devices').add({
        'user_id': userId,
        'name': 'Luz Cozinha',
        'type': 'simple',
        'room': 'Cozinha',
        'location': 'Teto',
        'status': true,
        'is_online': true,
        'is_favorite': false,
      });

      print('✅ Dados de exemplo inseridos com sucesso!');
    } catch (e) {
      print('❌ Erro ao inserir dados: $e');
    }
  }

  /// Limpa todos os dados de um usuário (útil para testes)
  static Future<void> clearUserData(String userId) async {
    try {
      // Apagar house
      await _firestore.collection('houses').doc(userId).delete();

      // Apagar todos os devices do usuário
      final devices = await _firestore
          .collection('devices')
          .where('user_id', isEqualTo: userId)
          .get();

      for (var doc in devices.docs) {
        await doc.reference.delete();
      }

      print('✅ Dados do usuário deletados com sucesso!');
    } catch (e) {
      print('❌ Erro ao deletar dados: $e');
    }
  }

  /// Resetar dados - apaga tudo e reinsere dados de exemplo
  static Future<void> resetData(String userId) async {
    await clearUserData(userId);
    await populateSampleData(userId);
  }
}

/// Como usar este arquivo:
///
/// 1. Importe no seu código
/// 2. Chame durante testes ou onboarding:
///
/// void main() async {
///   await Firebase.initializeApp();
///   final user = FirebaseAuth.instance.currentUser;
///   if (user != null) {
///     // Apenas executa uma vez
///     await FirestoreSampleData.populateSampleData(user.uid);
///   }
///   runApp(MyApp());
/// }
///
/// Ou em um botão de configuração:
/// 
/// FloatingActionButton(
///   onPressed: () => FirestoreSampleData.populateSampleData(userId),
///   child: Icon(Icons.refresh),
/// )
