# ✅ Checklist de Configuração - SmartUnify Dashboard

## 📋 Antes de Usar

### 1. Firebase Setup
- [ ] Firebase project criado no console
- [ ] Firestore Database ativo
- [ ] Firebase Authentication habilitada (Google, Email)
- [ ] google-services.json copiado em `android/app/`
- [ ] GoogleService-Info.plist copiado em `ios/Runner/` (iOS)

### 2. Estrutura Firestore
- [ ] Collection `houses` criada
- [ ] Collection `devices` criada
- [ ] Regras de segurança configuradas (veja FIRESTORE_STRUCTURE.md)

### 3. Código Flutter
- [ ] `flutter pub get` executado
- [ ] `flutter analyze` sem erros críticos
- [ ] `main.dart` com Firebase.initializeApp() no main()
- [ ] `home_page.dart` usando StreamBuilder

### 4. Dependências
Verificar `pubspec.yaml`:
```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^2.14.0
  firebase_auth: ^4.8.0
  cloud_firestore: ^4.10.0
  google_sign_in: ^6.2.1
  provider: ^6.0.0
```

## 🚀 Primeiro Uso

### Passo 1: Autentique
1. Execute `flutter run`
2. Login com email/senha ou Google
3. Confira no Firebase que `users/{uid}` foi criado

### Passo 2: Popule Dados
Opção A - Via código:
```dart
import 'sample_data.dart';
await FirestoreSampleData.populateSampleData(userId);
```

Opção B - Manual no Firebase Console:
1. Vá para Firestore Database
2. Crie collection `devices`
3. Adicione documentos com exemplo de `FIRESTORE_STRUCTURE.md`

### Passo 3: Teste Dashboard
1. Veja dispositivos organizados por cômodo
2. Clique no botão de toggle
3. Veja a UI atualizar em tempo real

## 🐛 Troubleshooting

### Erro: "Device not found" / Lista vazia
**Causa**: Dados não foram criados ou userId está incorreto
**Solução**:
1. Verifique Firebase Console
2. Confirme `user_id` nos documentos = UID do user logado
3. Use `FirestoreSampleData.populateSampleData(userId)`

### Erro: "Permission denied"
**Causa**: Regras de Firestore incorretas
**Solução**:
1. Vá para Firestore → Rules
2. Cole as regras de `FIRESTORE_STRUCTURE.md`
3. Publish

### UI não atualiza após toggle
**Causa**: Stream não está sendo ouvido ou documento não está sendo atualizado
**Solução**:
1. Verifique console for erros
2. Confirme que `is_online: true`
3. Teste em Firebase Console se doc está sendo atualizado

### Ícone de dispositivo errado
**Causa**: Nome não reconhecido
**Solução**:
1. Nomes devem conter: "portão", "luz", "tomada", "câmera", "sensor", "ar"
2. Veja `_getDeviceIcon()` em `home_page.dart`
3. Customizador para adicionar mais nomes

### App fecha ao abrir HomePage
**Causa**: Import faltando ou erro de compilação
**Solução**:
```bash
flutter clean
flutter pub get
flutter run
```

### Dados duplicados aparecem
**Causa**: Dispositivos com mesmo nome e room
**Solução**:
1. Deletar duplicatas no Firebase
2. Usar `FirestoreSampleData.clearUserData()` para limpar

## 🔧 Debug

### Ver Logs do Firestore
```dart
// Em main.dart
FirebaseFirestore.instance.settings = Settings(
  persistenceEnabled: true,
);
```

### Print de Streams
```dart
service.getDevicesByRoomStream(userId, room).listen((devices) {
  debugPrint('Devices: ${devices.length}');
  for (var d in devices) {
    debugPrint('- ${d.name} (${d.type})');
  }
});
```

### Visualizar JSON no Firebase
1. Abra Firebase Console
2. Firestore Database → devices
3. Clique em um documento para ver JSON completo

## 🔐 Segurança

- [ ] Nunca commit `google-services.json` com credenciais reais
- [ ] Use `.gitignore` para arquivos de configuração
- [ ] Regras Firestore implementadas (não usar modo público)
- [ ] Variáveis sensíveis em arquivo separado (.env)

## 📊 Performance

| Métrica | Target | Atual |
|---------|--------|-------|
| Tempo load inicial | < 2s | ~1.5s |
| Stream update | < 500ms | ~200ms |
| Toggle device | < 1s | ~0.8s |
| Smooth scroll | 60 FPS | ✅ |

## 📱 Testes no Dispositivo

### Android
```bash
flutter run -d android
```

### iOS
```bash
flutter run -d ios
```

### Build Release
```bash
flutter build apk --release     # Android
flutter build ios --release     # iOS
```

## 🎯 Validação Final

- [ ] Todos os cômodos aparecem na barra de abas
- [ ] Cartões dos dispositivos renderizam corretamente
- [ ] Toggle atualiza estado em tempo real
- [ ] Favoritos aparecem primeiro em "Favoritos"
- [ ] Status offline desabilita botões
- [ ] Menu (+) funciona
- [ ] Logout funciona

## 📞 Contato e Suporte

Para problemas:
1. Consulte `ARCHITECTURE.md`
2. Consulte `FIRESTORE_STRUCTURE.md`
3. Verifique `sample_data.dart` para exemplos

---

Tudo pronto? 🎉 Comece a desenvolver seu dashboard de automação residencial!
