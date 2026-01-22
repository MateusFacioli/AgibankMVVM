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


cmd+shift+l

Comandos git

Git checkout .
git clean  -d  -f
git pull origin develop
git log --all --decorate --oneline --graph
git revert commit_hash
git revert --no-commit commit_hash
git reset --hard  commit_hash && git clean -f
git push origin :branch_usada deleta e recria com o revert
git rebase --interactive HEAD~numcommits - agrupar commits p e s
:wq sai e salva do modo de edição
git fetch --prune - atualizar local com remoto/   (ajuda em pasta e file deletados)

Alterar nome branch
Vai para develop
git branch -m old-name new-name
git push origin --delete old-name (remote)
git push origin :old-name new-name 
git push origin -u new-name
git log
git push origin :bumblebee/feature/MBBATEND-10214
git branch -D bumblebee/feature/MBBATEND-10214
git checkout -b bumblebee/feature/MBBATEND-10214
git commit -a -m "Podfile to branch"
git push -u origin bumblebee/feature/MBBATEND-10214
git merge release/11.1.1
: x enter
git remote -v (Link projeto)
git push --set-upstream origin branch_sua
Git merge origin/branch_to_merge
git reset --hard @{1} && git reset --hard HEADˆ1
git reflog
git fetch
pod deintegrate
git /Users/t768607/Documents/IOS-BR-SNT-ON/SantanderOn.podspec
pod install --repo-update --clean-install
git commit --amend -m "New commit message." - alterar mensagem do commit


Pods

rm -rf Pods
rm Podfile.lock
pod install --repo-update
Pod update




Monolito
pod repo-art update itau-oq6-cocoapods

Terminal

Mv file move
mv file file2 renomeia
cp -R copia pasta e conteúdo  de forma recursiva
Rm -R remove pasta e conteúdo de forma recursiva
touch cria arquivo
Cat pega o arquivo
--no-ff 
   
ATALHOS DO XCODE
Navegar entre suas ações = control + command + *setas*
Quickhelp seleciona palavra = click + option
Identar o código = Seleciona o trecho do código -> control + i
Pesquisar arquivos = command + shift + o
Ir para a linha desejada = command + L
Code Snippets (views) = command + shift + L
Auto ident  =  option + command + L
Renomear nome de var (Refactor) = command + control + E
Selecionar uma ou mais linhas = command + shift + *setas*
Abrir caixa de sugestão = control + espaço || control + .
Colocar/Remover o breakpoint = command + \
Procurar funções e métodos = control + 6
Executar o projeto (BUILDAR) = command + B
Executar o projeto (RODAR) = command + R
Encontrar o arquivo aberto = command+shift+J
clean no xcode = command + shift + K or Command + Option + Shift + K
abrir os testes  = ctrl + shift + T
Fechar =  command + q
Cmd shift . = arquivo oculto
Cmd shift 3 = print editable
Abrir  arquivo direto tipo assistent = option + click
shift+ tab no terminal = todos os comandos
Cmd + option + [ ou ]  = move a linha
Cmd +option + n = cria pasta
cmd+ option + control + g = executa testes
