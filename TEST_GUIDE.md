# 🧪 Guia de Testes - SmartUnify Dashboard

## Teste Local Completo

### ✅ Pré-requisitos
- [ ] Flutter SDK instalado (>=3.11.5)
- [ ] Android Studio ou Xcode configurado
- [ ] Firebase project criado
- [ ] google-services.json copiado
- [ ] Firestore Database ativo
- [ ] Firebase Authentication ativa

---

## 🚀 Executar o App

### 1. Prepare o Ambiente

```bash
cd c:\Projetos\smart-unify-app

# Limpar build anterior
flutter clean

# Buscar dependências
flutter pub get

# Obter dependências do Flutter
flutter doctor
```

### 2. Compilar para Android

```bash
# Debug (rápido para desenvolvimento)
flutter run -d android

# Release (otimizado)
flutter build apk --release

# APK instalável em
# build/app/outputs/flutter-apk/app-release.apk
```

### 3. Compilar para iOS

```bash
# Debug
flutter run -d ios

# Release
flutter build ios --release
```

---

## 📱 Testar em Emulador/Dispositivo

### Android Emulator
```bash
# Ver emuladores disponíveis
flutter emulators

# Executar específico
flutter run -d emulator-5554

# Executar em qualquer disponível
flutter run
```

### iOS Simulator
```bash
# Debug no iPhone 14
flutter run -d "iPhone 14"

# Listar devices disponíveis
flutter devices
```

---

## 📝 Plano de Testes

### Teste 1: Inicialização

- [ ] App inicia sem crash
- [ ] AuthStatePage carrega
- [ ] Login page exibida se não autenticado
- [ ] HomePage exibida se autenticado

**Como testar**:
```bash
flutter run
# Verificar se HomePage carrega
```

### Teste 2: Dados de Teste

- [ ] PopulateSampleData() executa sem erro
- [ ] 11 dispositivos criados no Firestore
- [ ] Cômodos aparecem na barra de abas
- [ ] HomePage lista dispositivos

**Como testar**:
```dart
// Em login_page.dart, adicionar botão de teste:
ElevatedButton(
  onPressed: () async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirestoreSampleData.populateSampleData(user.uid);
      if(mounted) showSnackBar('Dados inseridos!');
    }
  },
  child: Text('Inserir Dados Teste'),
)

// Clicar no botão e verificar Firestore Console
```

### Teste 3: Navegação por Cômodos

**Cenário**: Usuário seleciona diferentes cômodos

- [ ] RoomTabBar renderiza corretamente
- [ ] "Favoritos" é primeiro
- [ ] Cômodos derivados dos dispositivos aparecem
- [ ] Seleção muda cor (azul)
- [ ] Grid atualiza ao trocar cômodo
- [ ] Sem lag ao mudar de cômodo

**Como testar**:
1. Rodar app com dados de teste
2. Clicar em diferentes abas
3. Verificar dispositivos corretos aparecem
4. Trocar rapidamente entre abas

### Teste 4: Cartão de Clima

- [ ] ClimateCard renderiza (2x1)
- [ ] Temperatura em grande (26°)
- [ ] Umidade e PM2.5 exibidos
- [ ] Gradiente de fundo aparece
- [ ] Ícone de clima correto
- [ ] Toque funciona

**Como testar**:
1. Rodar app
2. Verificar se "Sensor Sala" aparece
3. Validar tamanho, cores e dados
4. Clicar no cartão

### Teste 5: Cartão Simples

- [ ] SimpleDeviceCard renderiza (1x1)
- [ ] Nome e localização aparecem
- [ ] Ícone correto (portão, luz, etc)
- [ ] Status online/offline colorido
- [ ] Botão toggle no canto
- [ ] Tag de estado ("Online", "Offline")
- [ ] Coração de favorito funciona

**Como testar**:
1. Verificar dispositivos simples
2. Validar ícones (portão = 🚪)
3. Clicar em toggle
4. Clicar em coração

### Teste 6: Cartão de Switches

- [ ] SwitchGroupCard renderiza corretamente
- [ ] Nome e localização aparecem
- [ ] Botão master toggle exibido
- [ ] Status online/offline correto
- [ ] Switches individuais aparecem horizontalmente
- [ ] Switches coloridos (azul = ON, cinza = OFF)

**Como testar**:
1. Verificar "Painel Principal"
2. Validar layout
3. Clicar no master toggle
4. Clicar em switches individuais

### Teste 7: Toggle em Tempo Real

**Cenário**: Atualizar status reflete imediatamente

- [ ] Clique em toggle atualiza UI
- [ ] Firestore mostra novo status
- [ ] Sem lag na atualização
- [ ] Outros clients veem mudança em tempo real

**Como testar**:
1. Abrir Firebase Console em outro abas
2. Clicar toggle no app
3. Verificar Firestore atualiza
4. Verificar UI muda em <500ms

### Teste 8: Sistema de Favoritos

- [ ] Clique em ❤️ marca como favorito
- [ ] Corações ficam vermelhos
- [ ] Tab "Favoritos" mostra apenas favoritos
- [ ] Ordenação prioriza favoritos

**Como testar**:
1. Clique em coração de alguns dispositivos
2. Veja coração ficar vermelho
3. Mude para tab "Favoritos"
4. Verifique apenas favoritos aparecem

### Teste 9: Status Online/Offline

- [ ] Dispositivo offline tem cores cinza
- [ ] Botões desabilitados offline
- [ ] Toque não funciona offline
- [ ] Tag "Offline" aparece

**Como testar**:
1. Editar device no Firebase: is_online: false
2. Verificar UI muda
3. Tentar clicar (não funciona)

### Teste 10: Menu de Ações Rápidas

- [ ] Clique em botão + abre menu
- [ ] "Adicionar Dispositivo" opção
- [ ] "Escanear QR" opção
- [ ] Menu fecha ao clicar opção

**Como testar**:
1. Clicar botão + no header
2. Verificar menu bottom sheet
3. Clicar opções

### Teste 11: Logout

- [ ] Botão logout no header funciona
- [ ] Redireciona para LoginPage
- [ ] Session termina

**Como testar**:
1. Clicar em botão logout (🚪)
2. Verificar volta para login

### Teste 12: Responsividade

- [ ] Rotacionar device horizontal/vertical
- [ ] Layout adapta corretamente
- [ ] Sem overflow de elementos
- [ ] Scroll funciona

**Como testar**:
1. Rodar app
2. Rotacionar device
3. Verificar layout

---

## 🐛 Testes de Erro

### Erro 1: Sem Conexão Firestore

- [ ] HomePage trata erro graciosamente
- [ ] Mostra mensagem de erro
- [ ] Não trava

**Como simular**:
```bash
# Desabilitar internet no device
# Rodas flutter run
# Verificar tratamento de erro
```

### Erro 2: Sem Dados

- [ ] HomePage mostra "Nenhum dispositivo"
- [ ] UI não quebra
- [ ] Ícone de inbox vazio

**Como testar**:
1. Limpar todos os dispositivos
2. Verificar UI

### Erro 3: Permissão Negada

- [ ] Mensagem clara aparece
- [ ] Não mostra dados protegidos

**Como testar**:
1. Modificar regras Firestore para negar
2. Rodas app
3. Verificar erro

---

## ⚡ Testes de Performance

### FPS Test
- [ ] App roda a 60 FPS
- [ ] Sem jank ao navegar

**Como testar**:
```bash
flutter run --profile  # Profile mode
# Performance overlay: Pressione P
```

### Memory Test
- [ ] Memória estável
- [ ] Sem memory leaks
- [ ] <100MB em uso típico

**Como testar**:
```bash
flutter run --profile
# DevTools: Memory tab
```

### Load Time
- [ ] HomePage carrega em <2s
- [ ] Transições suaves <500ms
- [ ] Toggle atualiza em <1s

---

## 🎯 Checklist de Aceitação

### Funcionais
- [ ] Todos os widgets renderizam
- [ ] Toggles funcionam
- [ ] Favoritos funcionam
- [ ] Navegação funciona
- [ ] Logout funciona
- [ ] Dados carregam em tempo real

### UI/UX
- [ ] Cores corretas
- [ ] Tipografia legível
- [ ] Espaçamento profissional
- [ ] Ícones apropriados
- [ ] Responsivo

### Performance
- [ ] 60 FPS
- [ ] <2s carregamento
- [ ] <500ms transições
- [ ] Memória estável

### Segurança
- [ ] Tokens protegidos
- [ ] Dados criptografados
- [ ] Regras Firestore ativas
- [ ] Sem secrets expostos

### Documentação
- [ ] Todos os arquivos documentados
- [ ] Exemplos funcionam
- [ ] Troubleshooting completo
- [ ] Arquitetura clara

---

## 📊 Relatório de Teste

Template para documentar testes:

```markdown
## Teste: [Nome]
Data: [Data]
Device: [Android/iOS]
Versão Flutter: [Versão]

### Resultado: ✅ PASSOU / ❌ FALHOU

### Detalhes:
- [x] Subteste 1
- [x] Subteste 2
- [ ] Subteste 3 - Razão: [razão]

### Screenshots/Logs:
[Colar aqui]

### Notas:
[Adicionar observações]
```

---

## 🚀 Teste em Produção

### Pre-release
1. Build release para Android
2. Testar em múltiplos devices
3. Testar em múltiplas conexões
4. Testar com dados reais
5. Verificar performance

### Feedback
1. Coletar feedback de usuários
2. Monitorar crashes
3. Logs de performance
4. Análise de uso

---

## 📞 Quando Testar Falha

1. Verificar console Flutter para erros
2. Verificar Firestore Console
3. Verificar Firebase Logs
4. Rodar `flutter doctor`
5. Consultar SETUP_CHECKLIST.md

---

**Teste completo = App confiável! ✅**
