# 🏠 SmartUnify - Dashboard de Automação Residencial

## 🎯 O que foi Reconstruído

A interface principal (`home_page.dart`) foi completamente reconstruída com um **dashboard profissional** inspirado na UI da Tuya. O sistema agora oferece:

### ✨ Principais Melhorias

✅ **Cabeçalho Aprimorado**
- Título "Casa" com nome do usuário
- Botão flutuante (+) para ações rápidas
- Menu de contexto para adicionar dispositivo e escanear QR

✅ **Navegação por Cômodos**
- Barra de abas rolável e horizontal
- Sempre inicia com "Favoritos"
- Cômodos derivados automaticamente dos dispositivos

✅ **Cartões Dinâmicos e Profissionais**
- **ClimateCard**: Exibe temperatura grande, umidade, PM2.5 com gradiente elegante
- **SimpleDeviceCard**: Dispositivos simples com ícones adaptativos, status online/offline
- **SwitchGroupCard**: Múltiplos switches (W603) com botão de master + switches individuais

✅ **Estado em Tempo Real**
- StreamBuilder para cada filtro de cômodo
- Atualiza instantaneamente quando dispositivos mudam no Firebase
- Sem necessidade de refresh manual

✅ **Código Limpo e Modular**
- Componentes separados em arquivos individuais
- Singleton `FirestoreService` para operações com Firebase
- Modelos de dados bem definidos (`Device`, `House`, `DeviceChannel`)

## 📁 Estrutura do Projeto

```
lib/
├── main.dart                    # Entry point + Authentication
├── login_page.dart              # Página de login (existente)
├── home_page.dart               # ✨ NOVO - Dashboard profissional
├── add_device_page.dart         # Adicionar dispositivo (existente)
├── 
├── models/
│   └── device_model.dart        # ✨ NOVO - Models de dados
│
├── services/
│   └── firestore_service.dart   # ✨ NOVO - Serviço Firestore (singleton)
│
├── widgets/                      # ✨ NOVO - Componentes reutilizáveis
│   ├── climate_card.dart
│   ├── device_card.dart
│   ├── switch_group_card.dart
│   ├── room_tab_bar.dart
│   └── quick_actions_menu.dart
│
├── FIRESTORE_STRUCTURE.md       # ✨ NOVO - Documentação Firestore
├── ARCHITECTURE.md              # ✨ NOVO - Arquitetura completa
└── sample_data.dart             # ✨ NOVO - Dados de teste
```

## 🚀 Quick Start

### 1. Estrutura Esperada no Firestore

Antes de usar, ensure que seu Firestore tem este schema:

**Collection: `houses/{userId}`**
```json
{
  "name": "Casa",
  "location": "São Paulo, SP",
  "user_id": "abc123..."
}
```

**Collection: `devices/{deviceId}`**
```json
{
  "user_id": "abc123...",
  "name": "Portão Casa",
  "type": "simple|climate|switch_group",
  "room": "Área frente",
  "location": "Entrada principal",
  "status": false,
  "is_online": true,
  "is_favorite": false
}
```

Veja `lib/FIRESTORE_STRUCTURE.md` para exemplos completos.

### 2. Inserir Dados de Teste

Use o arquivo `lib/sample_data.dart`:

```dart
import 'sample_data.dart';

// Em algum lugar (ex: primeiro login)
final user = FirebaseAuth.instance.currentUser;
if (user != null) {
  await FirestoreSampleData.populateSampleData(user.uid);
}
```

Isso vai criar:
- 1 sensor de clima
- 4 dispositivos simples
- 1 painel com 3 switches
- E mais...

### 3. Compilar e Executar

```bash
cd c:\Projetos\smart-unify-app

# Atualizar dependências
flutter pub get

# Executar em debug
flutter run

# Ou build APK
flutter build apk --release
```

## 🎨 Tipos de Cartões

### ClimateCard (Clima)
```
┌────────────────────┐
│ Clima    ☀️         │
│ Sala de Estar      │
│                    │
│   26°              │
│ Temperatura        │
│                    │
│ Umidade 62% │ PM25 │
└────────────────────┘
```
- Type: `"climate"`
- Campos: `temperature`, `humidity`, `pm25`, `weather_type`

### SimpleDeviceCard (Dispositivo Simples)
```
┌──────────────┐
│ 🚪           │
│              │
│ Portão Casa  │
│ Entrada ...  │
│              │
│ Online  │ ⚡ │
└──────────────┘
```
- Type: `"simple"`
- Clique no ⚡ para toggle

### SwitchGroupCard (Múltiplos Switches)
```
┌──────────────────────────────┐
│ Painel Principal    ♡         │
│ Hall de entrada              │
│                              │
│ Energia    Online  [  Ligar ] │
│                              │
│ ┌────┬────┬────┐             │
│ │ Sala│Qto │Coz │             │
│ │ 🔵 │ ⚪ │ 🔵 │             │
│ └────┴────┴────┘             │
└──────────────────────────────┘
```
- Type: `"switch_group"`
- Campo: `channels: [{ id, name, status }, ...]`

## 🔄 Fluxo de Operação

1. **Usuário abre HomePage**
   - Busca lista de cômodos via `getRooms()`
   - RoomTabBar renderiza com "Favoritos" primeiro

2. **Usuário seleciona cômodo**
   - `_selectedRoom` muda
   - StreamBuilder dispara `getDevicesByRoomStream()`

3. **Firestore retorna dispositivos**
   - `_buildDeviceGrid()` renderiza cartões
   - Cada cartão mapeia para o tipo correto

4. **Usuário clica toggle**
   - `onToggle()` chama `toggleDeviceStatus()`
   - Firestore atualiza o documento
   - Stream emite novo valor
   - UI reconstrói com novo estado

## 📱 Componentes Principais

| Arquivo | Descrição | Props |
|---------|-----------|-------|
| `climate_card.dart` | Cartão de clima 2x1 | temperature, humidity, pm25, location, weatherType |
| `device_card.dart` | Cartão simples 1x1 | deviceName, location, isOnline, status, icon, isFavorite |
| `switch_group_card.dart` | Painel de switches | channels[], masterStatus, isOnline, isFavorite |
| `room_tab_bar.dart` | Barra de abas | rooms[], selectedRoom, onRoomSelected |
| `quick_actions_menu.dart` | Menu flutuante | onAddDevice, onScanQR |

## 🛠️ FirestoreService (Singleton)

Todas as operações com Firestore passam por este serviço:

```dart
final service = FirestoreService();

// Streams
Stream<List<Device>> devices = service.getDevicesByRoomStream(userId, room);

// Mutações
await service.toggleDeviceStatus(deviceId, currentStatus);
await service.toggleChannelStatus(deviceId, channelId, currentStatus);
await service.toggleFavorite(deviceId, isFavorite);

// Queries
List<String> rooms = await service.getRooms(userId);
```

## 🎯 Próximos Passos

- [ ] Implementar detalhes de dispositivos (tela de configurações)
- [ ] Adicionar scanner QR (implementar em `_handleScanQR`)
- [ ] Agendamento de dispositivos
- [ ] Automação/rotinas
- [ ] Histórico de eventos
- [ ] Notificações push em tempo real
- [ ] Controle por voz

## 📚 Documentação Completa

- **[ARCHITECTURE.md](lib/ARCHITECTURE.md)** - Arquitetura detalhada, componentes, fluxos
- **[FIRESTORE_STRUCTURE.md](lib/FIRESTORE_STRUCTURE.md)** - Schema do Firestore, exemplos, regras de segurança

## 🚨 Notas Importantes

### Status Online é Crítico
Quando `is_online: false`, o cartão desabilita cliques e mostra "Offline". Configure seus dispositivos IoT para atualizar este campo.

### Favoritos São Prioritários
Dispositivos com `is_favorite: true` aparecem primeiro e há um filtro "Favoritos" na barra de abas.

### Contexto Seguro
Todos os `if (context.mounted)` verificam se o widget ainda está na árvore antes de usar BuildContext após operações async.

### Ícones Adaptativos
SimpleDeviceCard reconhece nomes:
- "portão", "gate" → `door_front_door`
- "luz", "light" → `lightbulb`
- "tomada", "plug" → `power`
- "câmera" → `camera`
- "sensor", "smoke" → `sensors`
- "ar", "cooling" → `ac_unit`

## 🤝 Suporte

Para questões sobre a arquitetura, consulte:
1. `lib/ARCHITECTURE.md` - Visão geral
2. `lib/FIRESTORE_STRUCTURE.md` - Dados
3. Código-fonte dos widgets com comentários detalhados

---

**SmartUnify: Automação Residencial Profissional com Flutter + Firebase** 🚀
