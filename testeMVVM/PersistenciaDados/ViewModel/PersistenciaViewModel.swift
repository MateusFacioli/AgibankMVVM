//
//  PersistenciaViewModel.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 22/01/26.
//

import Foundation
import SwiftUI
import Combine

/// ViewModel simplificado para persistência de dados
class PersistenciaViewModel: ObservableObject {
    
    // MARK: - Dados para UserDefaults (Método tradicional)
    @Published var nomeUserDefaults: String = ""
    @Published var contadorUserDefaults: Int = 0
    private let userDefaults = UserDefaults.standard
    //ver o que salvei
    
    // MARK: - Dados para AppStorage (Método moderno SwiftUI)
    @AppStorage("appStorageNome") var nomeAppStorage: String = ""
    @AppStorage("appStorageContador") var contadorAppStorage: Int = 0
    @AppStorage("appStorageToggle") var toggleAppStorage: Bool = false
    
    // MARK: - Dados para JSON (Arquivo no Desktop/Documents)
    @Published var usuariosJSON: [Usuario] = []
    @Published var usuarioAtual = Usuario()
    @Published var mensagemStatus: String = "Pronto"
    
    private let jsonService = JSONService.shared
    
    // MARK: - Inicialização
    init() {
        print("🔵 ViewModel inicializado")
        carregarDadosIniciais()
    }
    
    // MARK: - UserDefaults
    func salvarComUserDefaults() {
        userDefaults.set(nomeUserDefaults, forKey: "nome_salvo")
        userDefaults.set(contadorUserDefaults, forKey: "contador_salvo")
        mensagemStatus = "✅ Salvo com UserDefaults"
    }
    
    func carregarUserDefaults() {
        nomeUserDefaults = userDefaults.string(forKey: "nome_salvo") ?? ""
        contadorUserDefaults = userDefaults.integer(forKey: "contador_salvo")
        mensagemStatus = "📂 Carregado do UserDefaults"
    }
    
    func limparUserDefaults() {
        userDefaults.removeObject(forKey: "nome_salvo")
        userDefaults.removeObject(forKey: "contador_salvo")
        nomeUserDefaults = ""
        contadorUserDefaults = 0
        mensagemStatus = "🗑️ UserDefaults limpo"
    }
    
    func userDefaultsTemDados() -> Bool {
        return userDefaults.string(forKey: "nome_salvo") != nil
    }
    
    // MARK: - AppStorage
    func aumentarContadorAppStorage() {
        contadorAppStorage += 1
        mensagemStatus = "🔢 Contador: \(contadorAppStorage)"
    }
    
    func limparAppStorage() {
        nomeAppStorage = ""
        contadorAppStorage = 0
        toggleAppStorage = false
        mensagemStatus = "🗑️ AppStorage limpo"
    }
    
    // MARK: - JSON (Arquivo)
    func salvarUsuariosJSON() {
        if jsonService.salvarUsuarios(usuariosJSON) {
            #if targetEnvironment(macCatalyst) || os(macOS)
            mensagemStatus = "✅ Salvo no Desktop do Mac!"
            #else
            mensagemStatus = "✅ Salvo no Documents do App!"
            #endif
        } else {
            mensagemStatus = "❌ Erro ao salvar JSON"
        }
    }
    
    func carregarUsuariosJSON() {
        if let usuarios = jsonService.carregarUsuarios() {
            usuariosJSON = usuarios
            mensagemStatus = "📂 \(usuarios.count) usuários carregados"
        } else {
            mensagemStatus = "📭 Nenhum usuário encontrado"
        }
    }
    
    func adicionarUsuarioJSON() {
        guard !usuarioAtual.nome.isEmpty else {
            mensagemStatus = "⚠️ Digite um nome"
            return
        }
        
        let novoUsuario = Usuario(
            nome: usuarioAtual.nome,
            email: usuarioAtual.email,
            idade: usuarioAtual.idade,
            ativo: usuarioAtual.ativo
        )
        
        usuariosJSON.append(novoUsuario)
        mensagemStatus = "👤 '\(novoUsuario.nome)' adicionado"
        
        // Limpa formulário
        usuarioAtual = Usuario()
    }
    
    func removerUsuarioJSON(at index: Int) {
        guard index < usuariosJSON.count else { return }
        let usuarioRemovido = usuariosJSON[index]
        usuariosJSON.remove(at: index)
        mensagemStatus = "🗑️ '\(usuarioRemovido.nome)' removido"
    }
    
    func jsonFileExiste() -> Bool {
        return jsonService.arquivoExiste()
    }
    
    func deletarArquivoJSON() {
        if jsonService.deletarArquivo() {
            usuariosJSON.removeAll()
            mensagemStatus = "🗑️ Arquivo deletado"
        } else {
            mensagemStatus = "⚠️ Arquivo não encontrado"
        }
    }
    
    func copiarCaminhoJSON() {
        UIPasteboard.general.string = jsonService.obterCaminhoArquivo()
        mensagemStatus = "📋 Caminho copiado!"
    }
    
    func mostrarInfoArquivo() {
        mensagemStatus = jsonService.obterInfoArquivo()
    }
    
    // MARK: - Métodos Auxiliares
    private func carregarDadosIniciais() {
        carregarUserDefaults()
        carregarUsuariosJSON()
        
        print("📊 Dados carregados:")
        print("   • UserDefaults: \(nomeUserDefaults)")
        print("   • AppStorage: \(nomeAppStorage)")
        print("   • AppStorage Toggle: \(toggleAppStorage)") 
        print("   • JSON: \(usuariosJSON.count) usuários")
    }
    
    /// Exporta todos os dados para exibição
    func exportarDados() -> String {
        var export = """
        ========== DADOS SALVOS ==========
        
        📦 USER DEFAULTS:
        • Nome: \(nomeUserDefaults)
        • Contador: \(contadorUserDefaults)
        • Tem dados: \(userDefaultsTemDados() ? "✅ Sim" : "❌ Não")
        
        📱 APP STORAGE:
        • Nome: \(nomeAppStorage)
        • Contador: \(contadorAppStorage)
        • Toggle: \(toggleAppStorage ? "✅ Ligado" : "❌ Desligado")
        
        📄 JSON FILE:
        • Arquivo existe: \(jsonFileExiste() ? "✅ Sim" : "❌ Não")
        • Total usuários: \(usuariosJSON.count)
        """
        
        if !usuariosJSON.isEmpty {
            export += "\n\n👤 USUÁRIOS NO JSON:"
            for (index, usuario) in usuariosJSON.enumerated() {
                export += "\n\(index + 1). \(usuario.nome) - \(usuario.email) (\(usuario.idade) anos)"
            }
        }
        
        export += "\n\n📍 JSON salvo em:\n\(jsonService.obterCaminhoArquivo())"
        export += "\n\n=============================="
        
        return export
    }
}
