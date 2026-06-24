# 📐 Diagrama da Arquitetura - SmartUnify Dashboard

## Estrutura de Pastas e Arquivos

```
smart-unify-app/
│
├── lib/
│   ├── main.dart                          ⭐ Entry point + Auth
│   ├── home_page.dart                     ✨ Dashboard principal (NOVO)
│   ├── login_page.dart                    🔐 Autenticação
│   ├── add_device_page.dart               ➕ Adicionar dispositivo
│   ├── video_player_page.dart             📹 Exibir vídeo
│   ├── sample_data.dart                   📊 Dados de teste (NOVO)
│   │
│   ├── models/                            📦 Camada de Dados
│   │   └── device_model.dart              Device, House, Channel
│   │
│   ├── services/                          🔌 Camada de Negócios
│   │   └── firestore_service.dart         Operações Firebase
│   │
│   ├── widgets/                           🎨 Componentes Reutilizáveis (NOVO)
│   │   ├── climate_card.dart              🌡️ Cartão de clima
│   │   ├── device_card.dart               📱 Cartão simples
│   │   ├── switch_group_card.dart         🔌 Painel de switches
│   │   ├── room_tab_bar.dart              🏠 Abas de cômodos
│   │   └── quick_actions_menu.dart        ⚡ Menu de ações
│   │
│   ├── ARCHITECTURE.md                    📚 Documentação técnica
│   ├── FIRESTORE_STRUCTURE.md             🗄️ Schema do banco
│   └── CUSTOMIZATIONS.md                  🎨 Temas e customizações
│
├── README_UPDATES.md                      📖 Resumo das mudanças
├── SETUP_CHECKLIST.md                     ✅ Checklist de setup
│
├── pubspec.yaml                           📦 Dependências
├── analysis_options.yaml                  🔍 Lint rules
└── ...
```

## Fluxo de Dados (Data Flow)

```
┌─────────────────────────────────────────────────────────────────┐
│                        Firebase Firestore                        │
│  ┌──────────────────┐  ┌──────────────────┐                    │
│  │  Collection:     │  │  Collection:     │                    │
│  │  houses/{uid}    │  │  devices/{id}    │                    │
│  └──────────────────┘  └──────────────────┘                    │
└────────────────────────────────────────────────────────────────┬┘
                             ▲  │
                             │  │
                    Leitura  │  │  Escrita
                  (Stream)   │  │ (Update)
                             │  ▼
                ┌────────────────────────────┐
                │   FirestoreService         │
                │   (Singleton)              │
                │ ┌────────────────────────┐ │
                │ │ • getDevicesByRoom()   │ │
                │ │ • toggleDeviceStatus() │ │
                │ │ • toggleFavorite()     │ │
                │ │ • getRooms()           │ │
                │ └────────────────────────┘ │
                └────────────────────────────┘
                             ▲  │
                             │  │
              StreamBuilder  │  │  setState
                             │  ▼
            ┌────────────────────────────────┐
            │        HomePage Widget         │
            │      (Stateful)                │
            │ ┌────────────────────────────┐ │
            │ │ _selectedRoom: String      │ │
            │ │ getRooms()                 │ │
            │ │ buildDeviceGrid()          │ │
            │ └────────────────────────────┘ │
            └────────────────────────────────┘
                             │
                  ┌──────────┼──────────┐
                  ▼          ▼          ▼
            ┌─────────┐ ┌────────┐ ┌──────────┐
            │ Climate │ │ Simple │ │ Switches │
            │  Card   │ │ Device │ │  Card    │
            └─────────┘ └────────┘ └──────────┘
```

## Ciclo de Vida do Toggle

```
Usuário clica toggle
        │
        ▼
    onToggle()
        │
        ▼
toggleDeviceStatus(id, currentStatus)
        │
        ▼
Firestore atualiza: status = !status
        │
        ▼
Listener no Stream é notificado
        │
        ▼
getDevicesByRoomStream() emite nova List<Device>
        │
        ▼
StreamBuilder detecta mudança
        │
        ▼
build() é chamado novamente
        │
        ▼
_buildDeviceCard() renderiza novo estado
        │
        ▼
UI atualiza com sucesso ✅
```

## Hierarquia de Widgets

```
MaterialApp
├── AuthStatePage (Stream<User?>)
│   ├── [User != null] → HomePage
│   │   └── Scaffold
│   │       ├── AppBar
│   │       │   └── FloatingActionButton (+)
│   │       │       └── QuickActionsMenu
│   │       └── Body: SingleChildScrollView
│   │           └── Column
│   │               ├── RoomTabBar
│   │               └── StreamBuilder<List<Device>>
│   │                   └── Column (_buildDeviceGrid)
│   │                       ├── ClimateCard (type: climate)
│   │                       ├── SimpleDeviceCard (type: simple)
│   │                       └── SwitchGroupCard (type: switch_group)
│   │                           └── Row (switches)
│   │                               └── SwitchChannel items
│   │
│   └── [User == null] → LoginPage
```

## Componentes e Dependências

```
main.dart
├── Firebase.initializeApp()
├── FirebaseAuth.authStateChanges()
└── AuthStatePage
    └── HomePage
        ├── imports: login_page, add_device_page
        ├── FirestoreService (singleton)
        ├── device_model.dart (Device, House)
        └── widgets/
            ├── climate_card.dart
            ├── device_card.dart
            ├── switch_group_card.dart
            ├── room_tab_bar.dart
            └── quick_actions_menu.dart

FirestoreService (singleton)
├── cloud_firestore (Firebase SDK)
└── device_model.dart (Models)

widgets/*
└── device_model.dart (para types)
```

## Estado do Dispositivo - Transições

```
                    ┌─────────────────────────┐
                    │      Device State       │
                    └─────────────────────────┘
                              │
                  ┌───────────┼───────────┐
                  │           │           │
                  ▼           ▼           ▼
            ┌─────────┐ ┌──────────┐ ┌─────────┐
            │ Online  │ │ Offline  │ │ Removed │
            │ Status  │ │ Status   │ │         │
            │ ON/OFF  │ │ Disabled │ │ Deleted │
            └─────────┘ └──────────┘ └─────────┘
                │            │           │
        ┌───────┼────────┐   │           │
        │       │        │   │           │
    ON  │   OFF │   Toggle   │           │
        ▼       ▼        ▼   │           │
      (true) (false) (updates)           │
                              │           │
                    ┌─────────┘           │
                    │                     │
            Stream emite novo            Firestore delete
              valor com status            documento
```

## Fluxo de Favoritos

```
SimpleDeviceCard / SwitchGroupCard
        │
        ▼
User clica ♥️ icon
        │
        ▼
onFavoriteTap()
        │
        ▼
toggleFavorite(deviceId, currentFavorite)
        │
        ▼
Firestore: is_favorite = !is_favorite
        │
        ▼
StreamBuilder notificado
        │
        ▼
Device com novo isFavorite renderizado
        ▼
RoomTabBar "Favoritos" atualiza
(se mudar favorito status)
```

## Estrutura de um Device no Firestore

```json
{
  "doc_id": "auto-generated-id",
  "user_id": "uid_do_usuario",
  "name": "Nome do dispositivo",
  "type": "simple|climate|switch_group",
  "room": "Cômodo",
  "location": "Localização",
  "status": true,
  "is_online": true,
  "is_favorite": false,
  
  "// Campos opcionais (climate)": {},
  "temperature": 26.5,
  "humidity": 65.0,
  "pm25": 35.0,
  "weather_type": "sunny",
  
  "// Campos opcionais (switch_group)": {},
  "channels": [
    { "id": "ch1", "name": "Canal 1", "status": true },
    { "id": "ch2", "name": "Canal 2", "status": false }
  ]
}
```

## Performance - Otimizações Implementadas

```
✅ StreamBuilder           → Apenas o cômodo selecionado
✅ FutureBuilder           → Cômodos carregados uma vez
✅ SingleChildScrollView   → Scroll suave
✅ Stateless Widgets       → Máximo reuso
✅ Ícones adaptativos      → String matching
✅ Lazy loading            → Widgets não renderizados fora da tela
✅ Singleton               → Uma única instância Firestore
✅ Ordem no Firestore      → favoritos primeiro (menos processing)
```

## Camadas da Arquitetura

```
┌────────────────────────────────────────────┐
│         Presentation Layer                 │
│     (Widgets / UI Components)              │
│  ┌──────────────────────────────────────┐  │
│  │ HomePage, ClimateCard,               │  │
│  │ SimpleDeviceCard, SwitchGroupCard    │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
            ▲                    │
            │                    ▼
┌────────────────────────────────────────────┐
│      Business Logic Layer                  │
│     (Model / Service)                      │
│  ┌──────────────────────────────────────┐  │
│  │ FirestoreService                     │  │
│  │ (getDevices, toggle, favorite)       │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
            ▲                    │
            │                    ▼
┌────────────────────────────────────────────┐
│         Data Layer                         │
│      (Models / Entities)                   │
│  ┌──────────────────────────────────────┐  │
│  │ Device, House, DeviceChannel         │  │
│  │ (Data classes + serialization)       │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
            ▲                    │
            │                    ▼
┌────────────────────────────────────────────┐
│      Database Layer                        │
│     (Firestore)                            │
│  ┌──────────────────────────────────────┐  │
│  │ Collections: houses, devices         │  │
│  │ Real-time listeners                  │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
```

## Padrões de Design Utilizados

```
✨ Singleton Pattern          → FirestoreService
✨ Stream Pattern             → Real-time updates
✨ Builder Pattern            → StreamBuilder, FutureBuilder
✨ Factory Pattern            → Device.fromMap()
✨ Observer Pattern           → Firestore listeners
✨ Model-View-Controller      → Separação de conceitos
✨ Composition                → Widgets compostos
✨ Immutability               → Device models
```

---

**Esta arquitetura garante escalabilidade, manutenibilidade e performance.** 🚀
