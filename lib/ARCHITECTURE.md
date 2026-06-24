# SmartUnify Dashboard - Arquitetura e Componentes

## 📋 Visão Geral

A interface principal foi completamente reconstruída com um design profissional inspirado na UI da Tuya. O sistema utiliza componentes modulares, gerenciamento de estado reativo com `StreamBuilder` e integração em tempo real com Firebase Firestore.

## 🏗️ Estrutura de Arquivos

```
lib/
├── main.dart                    # Entrada do app + Auth
├── home_page.dart              # Dashboard principal (reconstruído)
├── login_page.dart             # Página de login
├── add_device_page.dart        # Adicionar dispositivo
├── models/
│   └── device_model.dart       # Modelos de dados (Device, House, Channel)
├── services/
│   └── firestore_service.dart  # Serviço de Firestore (singleton)
└── widgets/
    ├── climate_card.dart       # Cartão de clima (2x1)
    ├── device_card.dart        # Cartão de dispositivo simples
    ├── switch_group_card.dart  # Cartão de múltiplos switches (W603)
    ├── room_tab_bar.dart       # Barra de abas por cômodo
    └── quick_actions_menu.dart # Menu flutuante de ações rápidas
```

## 🎨 Componentes Principais

### 1. **ClimateCard** (`widgets/climate_card.dart`)

Cartão de 2x1 para exibir informações de clima com design elegante.

**Características:**
- Temperatura em grande destaque
- Gradiente de fundo baseado no tipo de clima
- Exibição de umidade e PM2.5
- Ícones animados por tipo de clima

**Props:**
```dart
ClimateCard(
  temperature: 26.0,
  humidity: 65.0,
  pm25: 35.0,
  location: "Sala de Estar",
  weatherType: 'sunny',  // 'sunny', 'cloudy', 'rainy', 'stormy'
  onTap: () { },
)
```

### 2. **SimpleDeviceCard** (`widgets/device_card.dart`)

Cartão 1x1 para dispositivos simples (portões, luzes, tomadas, etc).

**Características:**
- Ícone adaptativo baseado no nome do dispositivo
- Status online/offline com cor diferenciada
- Tag discreta de estado (Ativo/Inativo)
- Botão flutuante de toggle
- Suporte a favoritos

**Props:**
```dart
SimpleDeviceCard(
  deviceName: "Portão Casa",
  location: "Entrada principal",
  isOnline: true,
  status: true,
  icon: Icons.door_front_door,
  onTap: () { },
  onToggle: () { },
  isFavorite: true,
  onFavoriteTap: () { },
)
```

### 3. **SwitchGroupCard** (`widgets/switch_group_card.dart`)

Cartão de largura total para dispositivos com múltiplos canais (W603).

**Características:**
- Botão de master toggle (energia geral)
- Fileira horizontal de switches individuais
- Cores diferentes para canais ativos/inativos
- Status online/offline visual
- Suporte a scroll horizontal para muitos canais

**Props:**
```dart
SwitchGroupCard(
  deviceName: "Painel Principal",
  location: "Hall de entrada",
  channels: [
    SwitchChannel(id: "ch1", name: "Sala", status: true),
    SwitchChannel(id: "ch2", name: "Quarto", status: false),
    SwitchChannel(id: "ch3", name: "Cozinha", status: true),
  ],
  isOnline: true,
  masterStatus: true,
  onChannelToggle: (channelId, newStatus) { },
  onMasterToggle: () { },
  onTap: () { },
)
```

### 4. **RoomTabBar** (`widgets/room_tab_bar.dart`)

Barra horizontal e rolável para filtrar por cômodos.

**Características:**
- Sempre inclui "Favoritos" como primeiro filtro
- Tabs derivados automaticamente dos dispositivos
- Seleção visual clara
- Scroll horizontal suave

**Props:**
```dart
RoomTabBar(
  rooms: ['Favoritos', 'Sala de Estar', 'Quarto', 'Cozinha'],
  selectedRoom: 'Sala de Estar',
  onRoomSelected: (room) { },
)
```

### 5. **QuickActionsMenu** (`widgets/quick_actions_menu.dart`)

Menu flutuante com ações rápidas (adicionar dispositivo, escanear QR).

**Características:**
- Botão + no header do app
- Menu bottom sheet elegante
- Ícones coloridos por ação

**Usage:**
```dart
QuickActionsMenu.show(
  context,
  onAddDevice: () { },
  onScanQR: () { },
);
```

## 📊 Modelos de Dados

### Device
```dart
class Device {
  String id;                        // ID do documento no Firestore
  String userId;                    // Proprietário
  String name;                      // Nome do dispositivo
  String type;                      // 'simple', 'climate', 'switch_group'
  String room;                      // Cômodo
  String location;                  // Localização específica
  bool status;                      // Estado geral
  bool isOnline;                    // Conectado?
  bool isFavorite;                  // É favorito?
  
  // Dados clima
  double? temperature;
  double? humidity;
  double? pm25;
  String? weatherType;
  
  // Dados switch group
  List<DeviceChannel>? channels;
}
```

### DeviceChannel
```dart
class DeviceChannel {
  String id;        // ID único do canal
  String name;      // Nome (ex: "Sala", "Quarto")
  bool status;      // Estado do canal
}
```

### House
```dart
class House {
  String userId;
  String name;      // Nome da casa (ex: "Casa")
  String location;  // Localização
}
```

## 🔄 Fluxo de Estado

```
HomePage (estateful)
    ↓
FutureBuilder → getRooms() → [Cômodos]
    ↓
RoomTabBar (seleção de cômodo)
    ↓
StreamBuilder → getDevicesByRoomStream()
    ↓
_buildDeviceGrid() → Lista de Device
    ↓
_buildDeviceCard() → Cartão específico
    ↓
onToggle/onChannelToggle
    ↓
toggleDeviceStatus() / toggleChannelStatus()
    ↓
Firestore atualiza
    ↓
Stream emite novo valor
    ↓
UI reconstrói em tempo real
```

## 🚀 Como Usar

### 1. Adicionar um Novo Dispositivo ao Firestore

```dart
await FirebaseFirestore.instance.collection('devices').add({
  'user_id': userId,
  'name': 'Portão Casa',
  'type': 'simple',
  'room': 'Área frente',
  'location': 'Entrada principal',
  'status': false,
  'is_online': true,
  'is_favorite': false,
});
```

### 2. Adicionar um Dispositivo de Clima

```dart
await FirebaseFirestore.instance.collection('devices').add({
  'user_id': userId,
  'name': 'Sensor Sala',
  'type': 'climate',
  'room': 'Sala de Estar',
  'location': 'Parede central',
  'status': true,
  'is_online': true,
  'is_favorite': false,
  'temperature': 24.3,
  'humidity': 58.0,
  'pm25': 28.0,
  'weather_type': 'sunny',
});
```

### 3. Adicionar um Dispositivo com Múltiplos Switches

```dart
await FirebaseFirestore.instance.collection('devices').add({
  'user_id': userId,
  'name': 'Painel Principal',
  'type': 'switch_group',
  'room': 'Entrada',
  'location': 'Hall de entrada',
  'status': true,
  'is_online': true,
  'is_favorite': true,
  'channels': [
    {'id': 'ch1', 'name': 'Sala', 'status': true},
    {'id': 'ch2', 'name': 'Quarto', 'status': false},
    {'id': 'ch3', 'name': 'Cozinha', 'status': true},
  ],
});
```

## 🎛️ FirestoreService (Singleton)

Toda interação com Firestore é feita através do `FirestoreService`:

```dart
final service = FirestoreService();

// Buscar streams de dispositivos
Stream<List<Device>> devices = service.getDevicesByRoomStream(userId, 'Sala de Estar');

// Atualizar status
await service.toggleDeviceStatus(deviceId, currentStatus);

// Atualizar canal
await service.toggleChannelStatus(deviceId, channelId, currentStatus);

// Favoritos
await service.toggleFavorite(deviceId, currentFavorite);

// Buscar cômodos
List<String> rooms = await service.getRooms(userId);
```

## 🎨 Temas e Cores

O app usa o `colorScheme` do Material 3 com `seedColor: Colors.deepPurple`. Todos os componentes respeitam o tema do app.

### Paleta Principal:
- **Primária**: Blue[600] - Ações, switches ativos
- **Sucesso**: Green[600] - Status online
- **Aviso**: Orange[400] - Clima
- **Erro**: Red - Favoritos
- **Neutro**: Grey - Estados inativos, borders

## 📱 Layout Responsivo

O layout foi pensado para diferentes tamanhos de tela:

- **Tablet**: Cartões com espaçamento aumentado
- **Phone**: Cartões ocupam a largura da tela
- **Landscape**: Scroll horizontal da barra de abas

## ⚡ Otimizações

1. **StreamBuilder**: Escuta em tempo real apenas do cômodo selecionado
2. **FutureBuilder**: Carrega cômodos uma vez ao inicializar
3. **SingleChildScrollView**: Permite scroll suave sem overflow
4. **Ícones adaptativos**: Reconhecem nomes de dispositivos
5. **Hot reload amigável**: Componentes stateless sempre que possível

## 🔒 Segurança no Firestore

Regras recomendadas (veja `FIRESTORE_STRUCTURE.md`):

```firestore
rules_version = '2';
service cloud.firestore {
  match /devices/{deviceId} {
    allow read, write: if request.auth.uid == resource.data.user_id;
  }
}
```

## 🔮 Próximas Implementações

- [ ] Detalhes do dispositivo (page)
- [ ] Agendamento de dispositivos
- [ ] Automação/rotinas
- [ ] Histórico de eventos
- [ ] Notificações em tempo real
- [ ] Scanner QR para adicionar dispositivos
- [ ] Controle por voz

## 📝 Notas Importantes

1. **Modelos são imutáveis**: Use `copyWith()` para atualizações
2. **SingleCharacterId para channels**: Use "ch1", "ch2", etc.
3. **Favoritos sempre primeiro**: Automático via ordenação no Firestore
4. **Status online é crítico**: Desabilita ações no UI se offline
5. **Context usage**: Verifique `context.mounted` antes de usar BuildContext em async

---

**Desenvolvido com ❤️ para automação residencial profissional.**
