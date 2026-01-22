# 📱 Persistência de Dados - Projeto Didático

Um app minimalista demonstrando diferentes formas de persistência de dados em SwiftUI usando MVVM.

## 🎯 Objetivos de Aprendizado

1. **UserDefaults** - Método tradicional do iOS
2. **@AppStorage** - Property Wrapper moderno do SwiftUI  
3. **Arquivos JSON** - Persistência estruturada em arquivo
4. **MVVM Pattern** - Arquitetura limpa e testável
5. **Codable Protocol** - Serialização fácil de objetos


## 🚀 Como Usar

### **1. UserDefaults (Tradicional)**
- Salva dados simples como strings e números
- Persistente entre sessões do app
- Não seguro para dados sensíveis

### **2. AppStorage (SwiftUI Moderno)**
- Property wrapper integrado com SwiftUI
- Reage automaticamente a mudanças
- Ideal para configurações da UI

### **3. JSON File (Estruturado)**
- Salva objetos complexos em arquivo
- Permite backup e restauração fácil
- Editável com qualquer editor de texto

## 📝 Exemplos de Código

### **UserDefaults:**
```swift
// Salvar
UserDefaults.standard.set("João", forKey: "nome")

// Carregar
let nome = UserDefaults.standard.string(forKey: "nome")


/Users/[seu-usuario]/Library/Developer/CoreSimulator/Devices/[device-id]/data/Containers/Data/Application/[app-id]/Documents/PersistenciaDados/usuarios.json

/Users/mateusrodrigues/Library/Developer/CoreSimulator/Devices/6150861E-FDBA-4A07-B14F-3297BA70F26C/data/Containers/Data/Application/44F0E496-2464-43A0-AD95-A4A204CABCD4/Documents/PersistenciaDados/usuarios.json


file:///Users/mateusrodrigues/Library/Developer/CoreSimulator/Devices/6150861E-FDBA-4A07-B14F-3297BA70F26C/data/Containers/Data/Application/A4C1ECF5-699C-4DCF-9511-1932572530C9/Documents/
