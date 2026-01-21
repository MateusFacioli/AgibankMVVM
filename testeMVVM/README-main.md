Prática 1:
Definir o projeto: controle de estoque
Arquitetura: MVVM
Linguagem: SwiftUI
Clean code: começando pela model -> viewmodel -> view
Obter inputs do user os dados da model

Prática 2:
Navegação
Coordinator
Viewcontroller
Refatorar: alterar ids do model para let, alterar funções de update e remove, nomes Classes e Pastas, comentários

Prática 3:
maps localizacao, coordenadas, precisao, reaproveitar conteudo -> checkbox, cadastrar item de galpao -> rotas no app de mapas - reforçar

Prática 4: 
api publica, get post delete

Prática 5: 
 notificaçoes e hardware -> face id, camera, giroscopio, permissoes
 info.plist
 persistencia de dados

Prática 6:
salvar dados (bloco de notas, arquivo nativo), segurança private, protected, persistencia de dados

pratica 7: 
jogo da memoria - mostrar
    arrastar um componente visual, dar zoom no emoji - não está pronto
    componente personalizado
    
 
Outros apps
app financeiro carteira etc
travellog - firebase
app logica
figma
push notification
tagueamento + analytics + acessibilidade 
ciclo de vida & authenticao token - mensagem 
modulos podfile cocoapods
banco de dados
upload de arquivos - pdf de comprovantes
funções de map, reduce
modularização do projeto + targets
semaforo
podfile

documentaçao com ///
 
#abordagens
-exercicios em arquivos e +testes +imagens teoria
-como comecar com o ui -> padrao de tela
- arquitetura MVVM - como fazer - reforçar
- api https://hgbrasil.com/docs/weather (URLComponents, URLQueryItem, URLSession, HTTPURLResponse)
- ciclo de vida - reforçar
- animações + lottie
- swift & swiftui - ok
- swiftdata e coredata  - reforçar
- lógica debug/log
- testes unitários - reforçar
- referencias com o java - criar
melhorar performance do app, testa, onde e pq - reforçar
- figma/ stitch


#melhorias
- criar botao cadastrar e remover na stockview e chamar os metodos da viewmodel
- criar botão limpar formulário
- criar dropdown para cidades em varios estados, países
- criar label que mostra a cidade selecionada alem da coordenada
- criar localização em tempo real //aulas
- criar botão de zoom - dragg functions //arrastar e soltar
- criar rota para onde digitamos // em aula
- swift nativo  alem do swiftui

"Quando o usuário clica no botão:
1. View → ViewModel: 'usuário clicou'
2. ViewModel → Service: 'solicite permissão'
3. Service → Sistema iOS: 'diálogo nativo'
4. Sistema → Service: 'usuário respondeu'
5. Service → ViewModel: 'aqui está a resposta'
6. ViewModel → View (via @Published): 'atualize a tela'
7. View: mostra novo estado automaticamente"
