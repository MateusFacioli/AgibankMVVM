//
//  LogManager.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 20/01/26.
//


import Foundation
import Combine

/// Gerenciador central de logs (Singleton)
 class LogManager: ObservableObject {
    static let shared = LogManager()
    
    @Published var todosLogs: [Log] = []
    private let userDefaultsKey = "logs_salvos"
    private let maxLogs = 100
    
    private init() {
        carregarLogs()
    }
    
    func adicionarLog(_ log: Log) {
        DispatchQueue.main.async {
            self.todosLogs.insert(log, at: 0)
            
            // Limitar número de logs
            if self.todosLogs.count > self.maxLogs {
                self.todosLogs.removeLast()
            }
            
            self.salvarLogs()
        }
    }
    
    func limparLogs() {
        todosLogs.removeAll()
        salvarLogs()
    }
    
    func filtrarLogs(por view: String?) -> [Log] {
        guard let view = view, !view.isEmpty else {
            return todosLogs
        }
        
        return todosLogs.filter { $0.view == view }
    }
    
    private func salvarLogs() {
        do {
            let data = try JSONEncoder().encode(todosLogs)
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        } catch {
            print("❌ Erro ao salvar logs: \(error)")
        }
    }
    
    private func carregarLogs() {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey) else { return }
        
        do {
            todosLogs = try JSONDecoder().decode([Log].self, from: data)
        } catch {
            print("❌ Erro ao carregar logs: \(error)")
        }
    }
}
