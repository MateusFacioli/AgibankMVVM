# Tutorial: Permissão de Calendário no iOS com SwiftUI

Um projeto didático demonstrando como solicitar permissão para acessar o calendário e criar eventos nativamente no iOS usando SwiftUI e arquitetura MVVM.

## 📋 Pré-requisitos

- Xcode 12+
- iOS 14+
- Swift 5+

## 🏗️ Estrutura do Projeto
MVVM Architecture:
├── Models/ # Modelos de dados
├── ViewModels/ # Lógica de negócio e estado
├── Views/ # Interface do usuário
└── Services/ # Serviços e integrações


## 🔧 Configuração Inicial

### 1. Adicionar Permissões no Info.plist

**Importante:** Você DEVE adicionar estas chaves no arquivo `Info.plist` do seu projeto:

<key>NSCalendarsUsageDescription</key>
<string>Mensagem mostrada ao usuário explicando por que precisa do acesso</string>

<key>NSCalendarsFullAccessUsageDescription</key>
<string>Mensagem para acesso completo ao calendário (iOS 17+)</string>

Como adicionar no Xcode:
Selecione seu projeto no navegador
Vá na aba "Info"
Clique no ícone "+" em "Custom iOS Target Properties" canto inferior esquerdo/ ou se preferir enter na lista e procure por privacy e terá acesso a todas propriedades do app 
Adicione as duas chaves acima

📱 Níveis de Permissão do Calendário

iOS 16 e anteriores:
Não Determinado: Usuário ainda não foi perguntado
Restrito: Bloqueado por restrições (controle parental)
Negado: Usuário recusou a permissão
Autorizado: Permissão básica concedida

iOS 17+ (Novo modelo de permissão):
Acesso Básico: Ler e criar eventos
Acesso Completo: Gerenciar todos os eventos
Escrita de Eventos: Apenas criar eventos (menos comum)

🚀 Fluxo da Aplicação
Passo 1: Verificar Status Atual
let status = EKEventStore.authorizationStatus(for: .event)
Passo 2: Solicitar Permissão

// iOS 17+
eventStore.requestFullAccessToEvents { granted, error in }

// Versões anteriores
eventStore.requestAccess(to: .event) { granted, error in }

Passo 3: Criar Evento (se permitido)
let evento = EKEvent(eventStore: eventStore)
evento.title = "Meu Evento"
evento.startDate = Date()
try eventStore.save(evento, span: .thisEvent)

💡 Pontos Importantes

1. Customizando a Mensagem de Permissão
A mensagem no Info.plist é CRUCIAL:
Seja claro e honesto
Explique o benefício para o usuário
Use linguagem amigável
Não pode ser vazia
Exemplo bom:
"Precisamos acessar seu calendário para adicionar eventos de reuniões que você agenda no app."

2. Tratando a Resposta do Usuário

O sistema fornece callbacks com:
granted: Booleano indicando se permitiu
error: Objeto de erro se algo falhou

3. Lidando com Permissão Negada

Se o usuário negar:
Não pergunte novamente imediatamente
Explique por que precisa da permissão
Forneça um botão para abrir Configurações
Respeite a decisão do usuário

4. Boas Práticas
Solicite permissão no contexto (quando for usar)
Não bloqueie funcionalidades essenciais
Forneça alternativa se possível
Teste todos os cenários de permissão

🧪 Testando
No Simulador:
App pergunta pela primeira vez
Pode simular diferentes respostas via Settings > Privacy > Calendars

Cenários para testar:
Primeiro acesso (notDetermined)
Permissão concedida
Permissão negada
Reabrir app após negar
Mudar permissão nas Configurações

🔍 Debug Tips
Verificar status atual:
print(EKEventStore.authorizationStatus(for: .event).rawValue)

Resetar permissões no simulador:
Settings > General > Reset > Reset Location & Privacy

Logs úteis:
EKErrorDomain para erros do EventKit
Verificar se há calendários disponíveis

📚 Recursos Adicionais
Documentação Apple - EventKit -> https://developer.apple.com/documentation/eventkit
Human Interface Guidelines - Privacy -> https://developer.apple.com/design/human-interface-guidelines/privacy
WWDC - Meet the new calendar and reminders authorization models -> https://developer.apple.com/videos/play/wwdc2023/10046/

🐛 Problemas Comuns
Mensagem não aparece: Verifique o Info.plist
Crash ao criar evento: Verifique se tem permissão
Evento não aparece: Verifique o calendário padrão
iOS 17 issues: Use os métodos novos de permissão


## RESUMO DOS PASSOS:

1. **Adicione as permissões no Info.plist** - Isso é OBRIGATÓRIO
2. **Crie os arquivos na estrutura MVVM** conforme acima
3. **Implemente a lógica no Service** para interagir com EventKit
4. **Crie o ViewModel** para gerenciar estado e lógica
5. **Desenvolva as Views** com SwiftUI
6. **Teste todos os cenários** de permissão

## PONTOS IMPORTANTES:

- **iOS 17+ tem novo modelo de permissão** - use `requestFullAccessToEvents`
- **Sempre verifique o status atual** antes de solicitar
- **Customize a mensagem no Info.plist** para ser amigável
- **Lide com todos os casos**: concedido, negado, restrito
- **Não solicite permissão no launch** - peça no contexto de uso
