# 🎨 Customizações e Temas - SmartUnify Dashboard

## Alterando o Tema Principal

### em `main.dart`:

```dart
MaterialApp(
  title: 'SmartUnify',
  theme: ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,  // ← Altere aqui
      brightness: Brightness.light,
    ),
  ),
  darkTheme: ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.dark,
    ),
  ),
  themeMode: ThemeMode.system,  // Segue preferência do sistema
)
```

## Cores Predefinidas Recomendadas

```dart
// Profissional
seedColor: Colors.blue          // Padrão
seedColor: Colors.indigo        // Sofisticado
seedColor: Colors.deepPurple    // Original

// Vibrante
seedColor: Colors.teal          // Moderno
seedColor: Colors.amber         // Quente

// Minimalista
seedColor: Colors.grey          // Neutro
seedColor: Colors.blueGrey      // Corporativo
```

## Customizar Ícones de Dispositivos

Em `home_page.dart`, método `_getDeviceIcon()`:

```dart
IconData _getDeviceIcon(String deviceName) {
  final name = deviceName.toLowerCase();
  
  // Adicione mais reconhecimentos:
  if (name.contains('ventilador')) {
    return Icons.air_outlined;
  } else if (name.contains('lavadora')) {
    return Icons.local_laundry_service;
  } else if (name.contains('geladeira')) {
    return Icons.kitchen;
  } else if (name.contains('tv') || name.contains('televisão')) {
    return Icons.tv;
  } else if (name.contains('fogão')) {
    return Icons.local_fire_department;
  }
  // ... resto do código
}
```

## Customizar Cores dos Cartões

### ClimateCard - Tipos de Clima

Em `widgets/climate_card.dart`:

```dart
Color _getBackgroundGradientStart() {
  switch (weatherType.toLowerCase()) {
    case 'snow':
      return Colors.cyan[300]!;
    case 'foggy':
      return Colors.blueGrey[300]!;
    // ... adicione mais
  }
}
```

### SimpleDeviceCard - Status Colors

```dart
Color _getStatusColor() {
  if (!isOnline) {
    return Colors.grey[400]!;
  }
  return status 
    ? Colors.green[400]!     // ← Altere para ativo
    : Colors.grey[300]!;
}
```

## Adicionar Animações

### Animar toggle de dispositivo

Em `home_page.dart`:

```dart
onToggle: () async {
  try {
    // Animação de feedback
    HapticFeedback.mediumImpact();
    
    await _firestoreService.toggleDeviceStatus(
      device.id,
      device.status,
    );
    
    // Optional: Mostrar toast com confirmação
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${device.name} ${!device.status ? 'ligado' : 'desligado'}'),
          duration: const Duration(milliseconds: 500),
        ),
      );
    }
  } catch (e) {
    // ... error handling
  }
}
```

Adicione import:
```dart
import 'package:flutter/services.dart';
```

## Layout Customizado - Grid vs Lista

### Trocar para Grid (2 colunas)

Substitua `_buildDeviceGrid()` em `home_page.dart`:

```dart
Widget _buildDeviceGrid(List<Device> devices) {
  return GridView.count(
    crossAxisCount: 2,
    crossAxisSpacing: 12,
    mainAxisSpacing: 12,
    padding: const EdgeInsets.symmetric(horizontal: 16),
    childAspectRatio: 0.8,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    children: List.generate(devices.length, (index) {
      final device = devices[index];
      return _buildDeviceCard(device);
    }),
  );
}
```

### Manter como ListaView (padrão)

Código atual já está otimizado com `SingleChildScrollView`.

## Adicionar Swipe de Deletar

No `home_page.dart`, em `_buildDeviceGrid()`:

```dart
Widget _buildDeviceCard(Device device) {
  return Dismissible(
    key: Key(device.id),
    direction: DismissDirection.endToStart,
    onDismissed: (direction) async {
      try {
        await _firestoreService.deleteDevice(device.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${device.name} deletado')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro: $e')),
          );
        }
      }
    },
    background: Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 16),
      color: Colors.red,
      child: const Icon(Icons.delete, color: Colors.white),
    ),
    child: _buildDeviceCard(device),  // Seu cartão aqui
  );
}
```

Adicione método em `services/firestore_service.dart`:

```dart
Future<void> deleteDevice(String deviceId) async {
  try {
    await _firestore.collection('devices').doc(deviceId).delete();
  } catch (e) {
    throw Exception('Erro ao deletar dispositivo: $e');
  }
}
```

## Mudar Layout do Header

### Header com Imagem de Fundo

```dart
AppBar(
  elevation: 0,
  backgroundColor: Colors.transparent,
  flexibleSpace: Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.blue[600]!, Colors.blue[800]!],
      ),
    ),
  ),
  // ... resto do header
)
```

### Header Mais Compacto

```dart
AppBar(
  elevation: 0,
  backgroundColor: Colors.white,
  title: Text('SmartUnify'),
  toolbarHeight: 56,  // Reduzir de 64 padrão
  // ...
)
```

## Customizar Spacing e Padding

### Cartões com mais espaço

Em cada widget, ajuste padding:

```dart
Padding(
  padding: const EdgeInsets.all(16.0),  // ← Aumentar/diminuir
  child: // ...
)
```

### Grid com mais gap

```dart
_buildDeviceGrid(List<Device> devices) {
  return Column(
    children: List.generate(
      devices.length,
      (index) => Padding(
        padding: const EdgeInsets.only(bottom: 16.0),  // ← Ajuste aqui
        child: _buildDeviceCard(devices[index]),
      ),
    ),
  );
}
```

## Adicionar Busca de Dispositivos

Em `home_page.dart`:

```dart
class _HomePageState extends State<HomePage> {
  late FirestoreService _firestoreService;
  String _selectedRoom = 'Favoritos';
  String _searchQuery = '';  // ← Novo

  // ...

  @override
  Widget build(BuildContext context) {
    // ...
    return Scaffold(
      // ...
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Barra de busca nova
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar dispositivos...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: (value) => setState(() => _searchQuery = value),
              ),
            ),
            // RoomTabBar, Grid, etc...
          ],
        ),
      ),
    );
  }
}
```

Depois filtrar:

```dart
final filtered = devices
  .where((d) => d.name.toLowerCase().contains(_searchQuery.toLowerCase()))
  .toList();

return _buildDeviceGrid(filtered);
```

## Dark Mode Completo

Widgets já respeitam `Theme.of(context)`, mas para forçar dark mode:

```dart
// Em main.dart
MaterialApp(
  themeMode: ThemeMode.dark,  // Força dark
  // ...
)
```

Widgets vão detectar automaticamente.

## Adicionar Notificações Toast

Já implementado com `ScaffoldMessenger`. Customizar:

```dart
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text('Dispositivo atualizado'),
    duration: const Duration(seconds: 2),
    backgroundColor: Colors.green,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    margin: const EdgeInsets.all(8),
    behavior: SnackBarBehavior.floating,
  ),
);
```

## Mudar Fonte do App

Em `main.dart`:

```dart
MaterialApp(
  // ...
  theme: ThemeData(
    useMaterial3: true,
    fontFamily: 'Inter',  // ou 'Roboto', 'Playfair'
  ),
)
```

Adicione em `pubspec.yaml`:

```yaml
flutter:
  fonts:
    - family: Inter
      fonts:
        - asset: assets/fonts/Inter-Regular.ttf
        - asset: assets/fonts/Inter-Bold.ttf
          weight: 700
```

## Ativar Material 3

Já ativo em `ThemeData`. Desativar:

```dart
ThemeData(
  useMaterial3: false,  // Volta a Material 2
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
)
```

## Próximas Customizações Recomendadas

- [ ] Add localization (pt-BR, en, es)
- [ ] Add animations library (shimmer loading)
- [ ] Add persistent cache (Hive)
- [ ] Add analytics (Firebase Analytics)
- [ ] Add crash reporting (Firebase Crashlytics)
- [ ] Add push notifications (Firebase Messaging)

---

**Customize o SmartUnify para sua marca! 🎨**
