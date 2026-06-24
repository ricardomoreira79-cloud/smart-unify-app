/**
 * Estrutura de Dados do Firestore para SmartUnify
 * ================================================
 * 
 * Este documento descreve como os dados devem ser organizados no Firestore
 * para que a aplicação funcione corretamente.
 */

// Collection: houses/{userId}
// Descrição: Informações da casa/residência do usuário
{
  "name": "Casa",                    // Nome da residência
  "location": "São Paulo, SP",       // Localização
  "user_id": "abc123..."             // ID do usuário proprietário
}

// Collection: devices/{deviceId}
// Descrição: Todos os dispositivos de automação residencial
{
  "user_id": "abc123...",            // Proprietário do dispositivo
  "name": "Portão Casa",             // Nome do dispositivo
  "type": "simple",                  // Tipo: 'simple', 'climate', 'switch_group'
  "room": "Área frente",             // Cômodo: 'Sala de Estar', 'Quarto', etc
  "location": "Entrada principal",   // Localização específica
  "status": true,                    // Status geral (true = ligado)
  "is_online": true,                 // Conectado à rede?
  "is_favorite": false,              // É favorito?
  
  // Campos específicos para tipo "climate"
  "temperature": 26.5,               // Temperatura em Celsius
  "humidity": 65.0,                  // Umidade em percentual
  "pm25": 35.0,                      // Índice PM2.5
  "weather_type": "sunny",           // Tipo de clima: 'sunny', 'cloudy', 'rainy', 'stormy'
  
  // Campos específicos para tipo "switch_group" (ex: W603)
  "channels": [
    {
      "id": "ch1",
      "name": "Luzes",
      "status": true
    },
    {
      "id": "ch2",
      "name": "Ventilador",
      "status": false
    },
    {
      "id": "ch3",
      "name": "Ar Condicionado",
      "status": true
    }
  ]
}

/**
 * Exemplos de Estrutura por Tipo de Dispositivo:
 */

// Tipo: "simple" (Dispositivo simples)
{
  "user_id": "user123",
  "name": "Portão Casa",
  "type": "simple",
  "room": "Área frente",
  "location": "Entrada principal",
  "status": false,
  "is_online": true,
  "is_favorite": true
}

// Tipo: "climate" (Sensor de clima)
{
  "user_id": "user123",
  "name": "Sensor Sala",
  "type": "climate",
  "room": "Sala de Estar",
  "location": "Parede central",
  "status": true,
  "is_online": true,
  "is_favorite": false,
  "temperature": 24.3,
  "humidity": 58.0,
  "pm25": 28.0,
  "weather_type": "sunny"
}

// Tipo: "switch_group" (Múltiplos switches - W603)
{
  "user_id": "user123",
  "name": "Painel Principal",
  "type": "switch_group",
  "room": "Entrada",
  "location": "Hall de entrada",
  "status": true,
  "is_online": true,
  "is_favorite": true,
  "channels": [
    {
      "id": "ch1",
      "name": "Sala",
      "status": true
    },
    {
      "id": "ch2",
      "name": "Quarto",
      "status": false
    },
    {
      "id": "ch3",
      "name": "Cozinha",
      "status": true
    }
  ]
}

/**
 * Regras de Segurança Recomendadas (Firebase Console):
 */

/*
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Usuários só podem ver suas próprias casas
    match /houses/{userId} {
      allow read, write: if request.auth.uid == userId;
    }
    
    // Usuários só podem ver/editar seus próprios dispositivos
    match /devices/{deviceId} {
      allow read, write: if request.auth.uid == resource.data.user_id;
      allow create: if request.auth.uid == request.resource.data.user_id;
    }
  }
}
*/

/**
 * Estrutura de Cômodos:
 * 
 * Os cômodos são derivados automaticamente do campo 'room' dos dispositivos.
 * A aplicação sempre adiciona 'Favoritos' como filtro especial.
 * 
 * Exemplos comuns:
 * - Favoritos (filtro especial)
 * - Sala de Estar
 * - Quarto
 * - Cozinha
 * - Banheiro
 * - Garagem
 * - Entrada
 * - Área Frente
 * - etc.
 */

/**
 * Fluxo de Atualização em Tempo Real:
 * 
 * 1. HomePage utiliza StreamBuilder com getDevicesByRoomStream()
 * 2. FirestoreService retorna um Stream que escuta mudanças no Firestore
 * 3. Quando um dispositivo é alterado (via botão toggle), toggleDeviceStatus() é chamado
 * 4. O Firestore dispara o evento de mudança
 * 5. O StreamBuilder é notificado e reconstrói os widgets automaticamente
 * 6. A UI reflete as mudanças em tempo real
 */
