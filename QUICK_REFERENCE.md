# 🗂️ Índice de Referência Rápida - SmartUnify Dashboard

## 📚 Documentação

### Conceitos e Arquitetura
- **[ARCHITECTURE.md](ARCHITECTURE.md)** - Arquitetura completa, componentes, fluxos de dados
- **[ARCHITECTURE_DIAGRAM.md](ARCHITECTURE_DIAGRAM.md)** - Diagramas visuais, hierarquias, padrões
- **[FIRESTORE_STRUCTURE.md](FIRESTORE_STRUCTURE.md)** - Schema do banco, segurança, exemplos

### Implementação e Setup
- **[README_UPDATES.md](README_UPDATES.md)** - Quick start, estrutura do projeto
- **[SETUP_CHECKLIST.md](SETUP_CHECKLIST.md)** - Checklist, troubleshooting, validação
- **[IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md)** - O que foi implementado, estatísticas

### Personalização
- **[CUSTOMIZATIONS.md](CUSTOMIZATIONS.md)** - Temas, cores, animações, layouts

---

## 📁 Arquivo Rápido por Tipo

### 🎨 Widgets (Componentes UI)
| Arquivo | Linhas | Propósito |
|---------|--------|----------|
| [climate_card.dart](lib/widgets/climate_card.dart) | 135 | Cartão de clima 2x1 |
| [device_card.dart](lib/widgets/device_card.dart) | 162 | Cartão simples 1x1 |
| [switch_group_card.dart](lib/widgets/switch_group_card.dart) | 237 | Painel de switches |
| [room_tab_bar.dart](lib/widgets/room_tab_bar.dart) | 57 | Abas de cômodos |
| [quick_actions_menu.dart](lib/widgets/quick_actions_menu.dart) | 75 | Menu de ações |

### 📊 Modelos de Dados
| Arquivo | Classe | Propósito |
|---------|--------|----------|
| [device_model.dart](lib/models/device_model.dart) | Device | Dispositivo IoT |
| [device_model.dart](lib/models/device_model.dart) | DeviceChannel | Canal de switch |
| [device_model.dart](lib/models/device_model.dart) | House | Residência |

### 🔌 Serviços
| Arquivo | Classe | Propósito |
|---------|--------|----------|
| [firestore_service.dart](lib/services/firestore_service.dart) | FirestoreService | Operações Firebase |

### 🏠 Páginas
| Arquivo | Classe | Propósito |
|---------|--------|----------|
| [home_page.dart](lib/home_page.dart) | HomePage | Dashboard principal |
| [login_page.dart](lib/login_page.dart) | LoginPage | Autenticação |
| [main.dart](lib/main.dart) | MyApp | Entry point |

### 📝 Utilitários
| Arquivo | Função | Propósito |
|---------|--------|----------|
| [sample_data.dart](lib/sample_data.dart) | populateSampleData() | Dados de teste |
| [sample_data.dart](lib/sample_data.dart) | clearUserData() | Limpar dados |

---

## 🎯 Fluxos Principais

### Flow 1: Listar Dispositivos
1. HomePage inicia
2. `getRooms()` busca cômodos
3. RoomTabBar renderiza
4. Usuário seleciona cômodo
5. `getDevicesByRoomStream()` emite List<Device>
6. `_buildDeviceGrid()` renderiza cartões

**Arquivo referência**: [home_page.dart](lib/home_page.dart) linha 160-200

### Flow 2: Toggle Device
1. Usuário clica botão toggle
2. `onToggle()` chamado
3. `toggleDeviceStatus()` executa
4. Firestore atualiza status
5. Stream emite novo Device
6. `build()` reconstrói
7. UI mostra novo estado

**Arquivo referência**: [home_page.dart](lib/home_page.dart) linha 290-310

### Flow 3: Gerenciar Favoritos
1. Usuário clica ♥️
2. `onFavoriteTap()` chamado
3. `toggleFavorite()` executa
4. Firestore atualiza is_favorite
5. Device renderiza com novo estado
6. RoomTabBar "Favoritos" atualiza

**Arquivo referência**: [home_page.dart](lib/home_page.dart) linha 340-360

---

## 💡 Soluções Rápidas

### "Como adicionar novo tipo de dispositivo?"
1. Adicionar `type` no Device.fromMap()
2. Adicionar case em `_buildDeviceCard()`
3. Criar novo widget (ex: light_card.dart)
4. Clonar estrutura de existing card
5. Customizar props e layout

**Referência**: [home_page.dart](lib/home_page.dart) linha 235-270

### "Como customizar cores?"
1. Abrir `main.dart`
2. Alterar `seedColor` em ColorScheme
3. Cores em widgets usam `Theme.of(context)`
4. Auto-aplicadas em todo app

**Referência**: [CUSTOMIZATIONS.md](CUSTOMIZATIONS.md) seção "Alterando o Tema"

### "Como adicionar novo ícone?"
1. Abrir `_getDeviceIcon()` em [home_page.dart](lib/home_page.dart)
2. Adicionar novo if/else com nome do dispositivo
3. Retornar Icon desejado
4. Teste com novo dispositivo

**Referência**: [home_page.dart](lib/home_page.dart) linha 370-390

### "Como testar localmente?"
1. Rodar `FirestoreSampleData.populateSampleData(userId)`
2. Verificar dados em Firebase Console
3. Executar `flutter run`
4. Testar toggles e navegação

**Referência**: [SETUP_CHECKLIST.md](SETUP_CHECKLIST.md) seção "Primeiro Uso"

---

## 🔍 Busca por Recurso

### Encontrar código para...

**...criar novo dispositivo**
- Firestore: [FIRESTORE_STRUCTURE.md](FIRESTORE_STRUCTURE.md#exemplos-de-estrutura-por-tipo-de-dispositivo)
- Code: [sample_data.dart](lib/sample_data.dart)

**...atualizar status**
- Service: [firestore_service.dart](lib/services/firestore_service.dart#40-55)
- Usage: [home_page.dart](lib/home_page.dart#290-310)

**...listar dispositivos**
- Service: [firestore_service.dart](lib/services/firestore_service.dart#12-35)
- Usage: [home_page.dart](lib/home_page.dart#160-180)

**...adicionar ação rápida**
- Widget: [quick_actions_menu.dart](lib/widgets/quick_actions_menu.dart)
- Usage: [home_page.dart](lib/home_page.dart#70-80)

**...criar novo cartão**
- Exemplos: [climate_card.dart](lib/widgets/climate_card.dart), [device_card.dart](lib/widgets/device_card.dart)
- Tutorial: [CUSTOMIZATIONS.md](CUSTOMIZATIONS.md#adicionar-swipe-de-deletar)

---

## 🚨 Erros Comuns

| Erro | Causa | Solução |
|------|-------|---------|
| "Device not found" | Dados não criados | Ver [SETUP_CHECKLIST.md](SETUP_CHECKLIST.md#erro-device-not-found--lista-vazia) |
| Permission denied | Regras Firestore | Ver [FIRESTORE_STRUCTURE.md](FIRESTORE_STRUCTURE.md#regras-de-segurança-recomendadas) |
| UI não atualiza | Stream não ativo | Ver [SETUP_CHECKLIST.md](SETUP_CHECKLIST.md#ui-não-atualiza-após-toggle) |
| Ícone errado | Nome não reconhecido | Ver [home_page.dart](lib/home_page.dart#_getDeviceIcon) |

---

## 📚 Por Conhecimento

### Se você quer aprender sobre...

**Arquitetura e Design Patterns**
→ [ARCHITECTURE_DIAGRAM.md](ARCHITECTURE_DIAGRAM.md)

**Estrutura de Dados no Firestore**
→ [FIRESTORE_STRUCTURE.md](FIRESTORE_STRUCTURE.md)

**Como usar cada Widget**
→ [ARCHITECTURE.md](ARCHITECTURE.md#-componentes-principais)

**Customizar Aparência**
→ [CUSTOMIZATIONS.md](CUSTOMIZATIONS.md)

**Troubleshooting e Erros**
→ [SETUP_CHECKLIST.md](SETUP_CHECKLIST.md#-troubleshooting)

**Próximos Passos**
→ [README_UPDATES.md](README_UPDATES.md#-próximos-passos)

---

## 🔗 Links Úteis

### Documentação Oficial
- [Flutter Docs](https://flutter.dev/docs)
- [Firebase Docs](https://firebase.google.com/docs)
- [Cloud Firestore](https://cloud.google.com/firestore/docs)
- [Material Design 3](https://m3.material.io/)

### Comunidade
- [Flutter Comunidade](https://flutter.dev/community)
- [Firebase Community](https://firebase.community)
- [Stack Overflow - flutter](https://stackoverflow.com/questions/tagged/flutter)

---

## 📞 Suporte Rápido

1. **Arquivo não compila?** → Rodar `flutter pub get` e `flutter clean`
2. **Widget não aparece?** → Verificar imports em [home_page.dart](lib/home_page.dart#L1-L12)
3. **Firestore não atualiza?** → Verificar regras em Firebase Console
4. **UI lenta?** → Ver otimizações em [ARCHITECTURE_DIAGRAM.md](ARCHITECTURE_DIAGRAM.md#performance---otimizações-implementadas)

---

## 📊 Estatísticas do Projeto

- **Total de arquivos criados**: 15
- **Total de linhas de código**: 2.400+
- **Total de linhas de documentação**: 1.400+
- **Componentes reutilizáveis**: 5
- **Modelos de dados**: 3
- **Serviços**: 1

---

**Última atualização**: Maio 2026  
**Versão**: 1.0.0  
**Status**: ✅ Pronto para Produção

Navegar por este índice para encontrar rapidamente o que você precisa! 🚀
