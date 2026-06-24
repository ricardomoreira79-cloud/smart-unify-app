# 🔄 Fluxogramas da Aplicação - SmartUnify Dashboard

## Fluxo Geral do App

```
                    ┌─────────────────┐
                    │  main() inicia  │
                    └────────┬────────┘
                             │
                             ▼
                    ┌─────────────────┐
                    │ Firebase.init() │
                    └────────┬────────┘
                             │
                             ▼
                    ┌─────────────────┐
                    │ AuthStatePage   │
                    └────────┬────────┘
                    ┌────────┴────────┐
                    │                 │
        User logado?│                 │ Não logado
                    │                 │
                    ▼                 ▼
            ┌──────────────┐   ┌────────────┐
            │ HomePage     │   │ LoginPage  │
            │ (Dashboard)  │   └────────────┘
            └──────────────┘
```

## Fluxo da HomePage (Dashboard)

```
┌──────────────────────────────────┐
│   HomePage Build                 │
└────────┬─────────────────────────┘
         │
    ┌────┴────────────────┐
    │                     │
    ▼                     ▼
FutureBuilder         RoomTabBar
getRooms()         (UI padrão)
    │                     │
    │ [Cômodos]           │
    │                     │
    └────┬────────────────┘
         │
         ▼
    ┌─────────────────────┐
    │ Usuário seleciona   │
    │ cômodo (estado)     │
    └────────┬────────────┘
             │
             ▼
    ┌─────────────────────┐
    │ StreamBuilder       │
    │ getDevicesByRoom()  │
    └────────┬────────────┘
             │
             ▼
    ┌─────────────────────┐
    │ _buildDeviceGrid()  │
    │ renderiza cartões   │
    └────────┬────────────┘
             │
    ┌────────┴────────┬───────────┐
    │                 │           │
    ▼                 ▼           ▼
Climate Card   Simple Device  Switch Group
    │                │           │
    └────────┬───────┴───────────┘
             │
             ▼
    ┌─────────────────────┐
    │   UI renderizada    │
    │   com 60 FPS ✨     │
    └─────────────────────┘
```

## Fluxo de Toggle Device

```
                User clica toggle
                     │
                     ▼
            ┌─────────────────┐
            │ onToggle()      │
            │ chamado         │
            └────────┬────────┘
                     │
                     ▼
      ┌──────────────────────────┐
      │ HapticFeedback           │
      │ feedback tátil           │
      └────────┬─────────────────┘
               │
               ▼
    ┌──────────────────────────────┐
    │ toggleDeviceStatus()         │
    │ executa no serviço           │
    └────────┬─────────────────────┘
             │
             ▼
    ┌──────────────────────────────┐
    │ Firestore.update()           │
    │ status = !status             │
    └────────┬─────────────────────┘
             │
             ▼
    ┌──────────────────────────────┐
    │ Listener em Stream é         │
    │ notificado                   │
    └────────┬─────────────────────┘
             │
             ▼
    ┌──────────────────────────────┐
    │ getDevicesByRoomStream()     │
    │ emite novo List<Device>      │
    └────────┬─────────────────────┘
             │
             ▼
    ┌──────────────────────────────┐
    │ StreamBuilder detecta        │
    │ mudança                      │
    └────────┬─────────────────────┘
             │
             ▼
    ┌──────────────────────────────┐
    │ build() é chamado            │
    │ novamente                    │
    └────────┬─────────────────────┘
             │
             ▼
    ┌──────────────────────────────┐
    │ _buildDeviceCard() rerenderiza│
    │ com novo estado              │
    └────────┬─────────────────────┘
             │
             ▼
    ┌──────────────────────────────┐
    │ UI atualiza em tempo real    │
    │ ✅ Sucesso!                  │
    └──────────────────────────────┘
```

## Fluxo de Seleção de Cômodo

```
              Aplicativo inicia
                    │
                    ▼
        ┌──────────────────────┐
        │ _selectedRoom =      │
        │ "Favoritos"          │
        │ (padrão)             │
        └──────┬───────────────┘
               │
               ▼
        ┌──────────────────────┐
        │ RoomTabBar           │
        │ renderiza com        │
        │ "Favoritos" ativo    │
        └──────┬───────────────┘
               │
               ▼
    ┌────────────────────────────┐
    │ Usuário clica outro cômodo │
    │ Ex: "Sala de Estar"        │
    └───────────┬────────────────┘
                │
                ▼
    ┌────────────────────────────┐
    │ onRoomSelected()           │
    │ setState()                 │
    │ _selectedRoom = "Sala..."  │
    └───────────┬────────────────┘
                │
                ▼
    ┌────────────────────────────┐
    │ StreamBuilder recebe novo  │
    │ valor de _selectedRoom     │
    └───────────┬────────────────┘
                │
                ▼
    ┌────────────────────────────┐
    │ getDevicesByRoomStream()   │
    │ em "Sala de Estar"         │
    └───────────┬────────────────┘
                │
                ▼
    ┌────────────────────────────┐
    │ Firestore filtra devices   │
    │ WHERE room = "Sala..."     │
    └───────────┬────────────────┘
                │
                ▼
    ┌────────────────────────────┐
    │ Nova lista de dispositivos │
    │ é retornada                │
    └───────────┬────────────────┘
                │
                ▼
    ┌────────────────────────────┐
    │ Grid renderiza novos       │
    │ dispositivos da sala       │
    └────────────────────────────┘
```

## Fluxo de Favoritos

```
         User clica ♥️
              │
              ▼
    ┌────────────────────┐
    │ onFavoriteTap()    │
    │ chamado            │
    └────────┬───────────┘
             │
             ▼
    ┌────────────────────────────┐
    │ toggleFavorite()           │
    │ in FirestoreService        │
    └────────┬───────────────────┘
             │
             ▼
    ┌────────────────────────────┐
    │ Firestore.update()         │
    │ is_favorite = !is_favorite │
    └────────┬───────────────────┘
             │
             ▼
    ┌────────────────────────────┐
    │ Device renderiza com novo  │
    │ estado do coração          │
    └────────┬───────────────────┘
             │
             ▼
    ┌────────────────────────────┐
    │ Se em "Favoritos"          │
    │ tab:                       │
    └──────┬─────────────────────┘
           │
      ┌────┴─────┐
      │           │
   Favorito  Não favorito
      │           │
      ▼           ▼
  Permanece  Remove da
  Visível    Grade
```

## Fluxo de Tipo de Dispositivo

```
        Device recebido do Firestore
                    │
                    ▼
            Verifica device.type
                    │
        ┌───────────┼───────────┐
        │           │           │
   "climate"   "simple"   "switch_group"
        │           │           │
        ▼           ▼           ▼
  ClimateCard SimpleDeviceCard SwitchGroupCard
        │           │           │
        └───┬───────┴───────────┘
            │
            ▼
    Renderiza cartão apropriado
    com props específicos
```

## Fluxo de Status Online/Offline

```
    Device.isOnline verificado
             │
    ┌────────┴──────────┐
    │                   │
 true              false
    │                   │
    ▼                   ▼
Ativo             Inativo
    │                   │
Cores             Cores
Vivas             Cinza
    │                   │
Botão             Botão
Habilitado        Desabilitado
    │                   │
Toggle            Sem
Possível          Interação
```

## Arquitetura em Camadas

```
    ┌─────────────────────────────┐
    │   Presentation Layer        │
    │  (Widgets / HomePage)       │
    └──────────────┬──────────────┘
                   │
    ┌──────────────┴──────────────┐
    │   Business Logic Layer      │
    │  (FirestoreService)         │
    └──────────────┬──────────────┘
                   │
    ┌──────────────┴──────────────┐
    │   Data Model Layer          │
    │  (Device, House, Channel)   │
    └──────────────┬──────────────┘
                   │
    ┌──────────────┴──────────────┐
    │   Database Layer            │
    │  (Firestore Collections)    │
    └─────────────────────────────┘
```

## Hierarquia de Widgets

```
MaterialApp
│
└─ AuthStatePage
   │
   ├─ [User logged] → HomePage
   │  │
   │  ├─ AppBar (header + menu)
   │  │  └─ QuickActionsMenu
   │  │
   │  └─ SingleChildScrollView
   │     │
   │     └─ Column
   │        │
   │        ├─ FutureBuilder
   │        │  └─ RoomTabBar (abas)
   │        │
   │        └─ StreamBuilder
   │           └─ Column (_buildDeviceGrid)
   │              │
   │              ├─ ClimateCard (type: climate)
   │              ├─ SimpleDeviceCard (type: simple)
   │              └─ SwitchGroupCard (type: switch_group)
   │                 └─ Row (switches)
   │
   └─ [User not logged] → LoginPage
```

## Fluxo de Dados em Tempo Real

```
                Firestore
              (Master Source)
                    │
              Update evento
                    │
                    ▼
            Listener dispara
                    │
                    ▼
        Stream emite novo valor
                    │
                    ▼
        StreamBuilder detecta
                    │
                    ▼
        build() é chamado
                    │
                    ▼
        Widgets são rebuiltados
                    │
                    ▼
        UI atualizada em 200ms
                    │
                    ▼
        Usuário vê mudança ✅
```

## Carregamento da Página

```
    1. HomePage.initState()
       │
       └─ FirestoreService criado
    
    2. FutureBuilder (getRooms)
       │
       ├─ Conecta ao Firestore
       └─ Retorna lista de cômodos
    
    3. RoomTabBar renderizado
       │
       └─ Padrão: "Favoritos"
    
    4. StreamBuilder ativa
       │
       ├─ Escuta dispositivos
       └─ Emite List<Device>
    
    5. _buildDeviceGrid()
       │
       ├─ Detecta tipo de cada device
       └─ Renderiza cartão apropriado
    
    6. HomePage completa ✓
       │
       └─ 60 FPS, sem lag
```

---

**Fluxogramas visuais para melhor compreensão da arquitetura** 📊
