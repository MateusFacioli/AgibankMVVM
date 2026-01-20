# 📱 Projeto Didático: Ciclo de Vida SwiftUI/MVVM

Um projeto completo demonstrando o ciclo de vida em SwiftUI usando arquitetura MVVM, com explicações detalhadas de cada etapa.

## 🎯 Objetivos do Projeto

1. **Ensinar o ciclo de vida** de Views em SwiftUI
2. **Demonstrar arquitetura MVVM** na prática
3. **Mostrar equivalências** entre SwiftUI e UIKit
4. **Criar ferramentas didáticas** para ensino

## 🏗️ Arquitetura MVVM

### **Model**
- `EtapaCiclo`: Modelo de dados para etapas do ciclo
- `Log`: Registro de eventos do sistema
- `DadosCiclo`: Dados estáticos do projeto

### **ViewModel**
- `CicloDeVidaViewModel`: Gerencia estado e lógica do app
- `LogManager`: Singleton para gerenciamento central de logs
- Usa `@Published` para atualização automática da View

### **View**
- Views declarativas com SwiftUI
- Reagem automaticamente a mudanças no ViewModel
- Separadas por responsabilidade

## 🔄 Ciclo de Vida Demonstrado

### **SwiftUI**
- `init()`: Inicialização da struct View
- `body`: Propriedade computada (equivalente a loadView)
- `onAppear`: View aparece na tela
- `onDisappear`: View desaparece
- `onChange`: Observa mudanças em propriedades
- `task`: Tarefas assíncronas
- `scenePhase`: Ciclo de vida do app

### **UIKit (Para Comparação)**
- `viewDidLoad`: Controller carregado
- `viewWillAppear`: Prestes a aparecer
- `viewDidAppear`: Apareceu completamente
- `viewWillDisappear`: Prestes a desaparecer
- `viewDidDisappear`: Desapareceu completamente
- `deinit`: Destruição do objeto

## 📱 Telas do App

### **1. Dashboard**
- Visão geral do ciclo de vida ativo
- Estatísticas em tempo real
- Controles interativos

### **2. Etapas Detalhadas**
- Lista completa de todas as etapas
- Comparação UIKit vs SwiftUI
- Explicações detalhadas

### **3. Logs do Sistema**
- Registro de todos os eventos
- Filtros por view e tipo
- Exportação de logs

### **4. Configurações**
- Estatísticas do sistema
- Ações administrativas
- Informações técnicas

## 🛠️ Funcionalidades Técnicas

### **Reatividade com Combine**
```swift
@Published var contadorAparicoes: Int = 0
// View atualiza automaticamente quando muda
