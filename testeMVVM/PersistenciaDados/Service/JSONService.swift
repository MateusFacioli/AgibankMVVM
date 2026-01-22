//
//  JSONService.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 22/01/26.
//

import Foundation

/// Serviço simplificado para salvar JSON no Desktop do Mac
class JSONService {
    static let shared = JSONService()
    
    private let fileManager = FileManager.default
    private let fileName = "usuarios.json"
    
    // MARK: - Caminhos do arquivo
    
    /// Retorna o caminho para salvar no Desktop do usuário
    private var desktopFileURL: URL {
        let desktopURL = fileManager.urls(for: .desktopDirectory, in: .userDomainMask).first!
        return desktopURL.appendingPathComponent(fileName)
    }
    
    /// Retorna o caminho para salvar no Documents do app (sandbox)
    private var documentsFileURL: URL {
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsURL.appendingPathComponent(fileName)
    }
    
    // MARK: - Métodos Públicos Simples
    
    /// Salva usuários no Desktop (Mac) ou Documents (iOS)
    func salvarUsuarios(_ usuarios: [Usuario]) -> Bool {
        #if targetEnvironment(macCatalyst) || os(macOS)
        // Para Mac: salva no Desktop
        return salvarNoDesktop(usuarios)
        #else
        // Para iOS: salva no Documents
        return salvarNoDocuments(usuarios)
        #endif
    }
    
    /// Carrega usuários do Desktop (Mac) ou Documents (iOS)
    func carregarUsuarios() -> [Usuario]? {
        #if targetEnvironment(macCatalyst) || os(macOS)
        // Para Mac: carrega do Desktop
        return carregarDoDesktop()
        #else
        // Para iOS: carrega do Documents
        return carregarDoDocuments()
        #endif
    }
    
    /// Verifica se o arquivo existe
    func arquivoExiste() -> Bool {
        #if targetEnvironment(macCatalyst) || os(macOS)
        return fileManager.fileExists(atPath: desktopFileURL.path)
        #else
        return fileManager.fileExists(atPath: documentsFileURL.path)
        #endif
    }
    
    /// Deleta o arquivo
    func deletarArquivo() -> Bool {
        #if targetEnvironment(macCatalyst) || os(macOS)
        return deletarDoDesktop()
        #else
        return deletarDoDocuments()
        #endif
    }
    
    // MARK: - Métodos Específicos para Desktop (Mac)
    
    private func salvarNoDesktop(_ usuarios: [Usuario]) -> Bool {
        let fileURL = desktopFileURL
        print("💾 Salvando no Desktop: \(fileURL.path)")
        
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(usuarios)
            try data.write(to: fileURL)
            
            print("✅ Salvo com sucesso no Desktop!")
            return true
        } catch {
            print("❌ Erro ao salvar no Desktop: \(error)")
            return false
        }
    }
    
    private func carregarDoDesktop() -> [Usuario]? {
        let fileURL = desktopFileURL
        
        guard fileManager.fileExists(atPath: fileURL.path) else {
            print("📭 Arquivo não encontrado no Desktop")
            return nil
        }
        
        print("📂 Carregando do Desktop: \(fileURL.path)")
        
        do {
            let data = try Data(contentsOf: fileURL)
            let usuarios = try JSONDecoder().decode([Usuario].self, from: data)
            print("✅ Carregado: \(usuarios.count) usuários")
            return usuarios
        } catch {
            print("❌ Erro ao carregar do Desktop: \(error)")
            return nil
        }
    }
    
    private func deletarDoDesktop() -> Bool {
        let fileURL = desktopFileURL
        
        guard fileManager.fileExists(atPath: fileURL.path) else {
            print("⚠️ Arquivo não existe no Desktop")
            return false
        }
        
        do {
            try fileManager.removeItem(at: fileURL)
            print("🗑️ Arquivo deletado do Desktop")
            return true
        } catch {
            print("❌ Erro ao deletar do Desktop: \(error)")
            return false
        }
    }
    
    // MARK: - Métodos Específicos para Documents (iOS)
    
    private func salvarNoDocuments(_ usuarios: [Usuario]) -> Bool {
        let fileURL = documentsFileURL
        print("💾 Salvando no Documents: \(fileURL.path)")
        
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(usuarios)
            try data.write(to: fileURL)
            
            print("✅ Salvo com sucesso no Documents!")
            return true
        } catch {
            print("❌ Erro ao salvar no Documents: \(error)")
            return false
        }
    }
    
    private func carregarDoDocuments() -> [Usuario]? {
        let fileURL = documentsFileURL
        
        guard fileManager.fileExists(atPath: fileURL.path) else {
            print("📭 Arquivo não encontrado no Documents")
            return nil
        }
        
        print("📂 Carregando do Documents: \(fileURL.path)")
        
        do {
            let data = try Data(contentsOf: fileURL)
            let usuarios = try JSONDecoder().decode([Usuario].self, from: data)
            print("✅ Carregado: \(usuarios.count) usuários")
            return usuarios
        } catch {
            print("❌ Erro ao carregar do Documents: \(error)")
            return nil
        }
    }
    
    private func deletarDoDocuments() -> Bool {
        let fileURL = documentsFileURL
        
        guard fileManager.fileExists(atPath: fileURL.path) else {
            print("⚠️ Arquivo não existe no Documents")
            return false
        }
        
        do {
            try fileManager.removeItem(at: fileURL)
            print("🗑️ Arquivo deletado do Documents")
            return true
        } catch {
            print("❌ Erro ao deletar do Documents: \(error)")
            return false
        }
    }
    
    // MARK: - Métodos de Informação
    
    /// Retorna o caminho do arquivo para exibição
    func obterCaminhoArquivo() -> String {
        #if targetEnvironment(macCatalyst) || os(macOS)
        return desktopFileURL.path
        #else
        return documentsFileURL.path
        #endif
    }
    
    /// Retorna informações do arquivo
    func obterInfoArquivo() -> String {
        #if targetEnvironment(macCatalyst) || os(macOS)
        let local = "Desktop do Mac"
        let fileURL = desktopFileURL
        #else
        let local = "Documents do App"
        let fileURL = documentsFileURL
        #endif
        
        let existe = arquivoExiste() ? "✅ Sim" : "❌ Não"
        
        var info = """
        📍 Local: \(local)
        📄 Arquivo: \(fileName)
        ✅ Existe: \(existe)
        """
        
        if arquivoExiste() {
            do {
                let attributes = try fileManager.attributesOfItem(atPath: fileURL.path)
                let size = attributes[.size] as? Int ?? 0
                info += "\n📏 Tamanho: \(size) bytes"
            } catch {
                info += "\n❌ Erro ao ler atributos"
            }
        }
        
        info += "\n\n📂 Caminho:\n\(fileURL.path)"
        
        return info
    }
}
