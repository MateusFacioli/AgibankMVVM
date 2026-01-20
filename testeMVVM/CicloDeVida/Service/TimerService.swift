//
//  TimerService.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 20/01/26.
//


import Foundation
import Combine

/// Serviço para gerenciamento de timers com Combine
class TimerService {
    static let shared = TimerService()
    
    private var timers: [String: AnyCancellable] = [:]
    
    private init() {}
    
    /// Inicia um timer com um identificador único
    func iniciarTimer(
        id: String,
        intervalo: TimeInterval = 1.0,
        onTick: @escaping () -> Void
    ) {
        pararTimer(id: id)
        
        let timer = Timer.publish(every: intervalo, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                onTick()
            }
        
        timers[id] = timer
        print("⏱️ TimerService: Timer '\(id)' iniciado")
    }
    
    /// Para um timer específico
    func pararTimer(id: String) {
        timers[id]?.cancel()
        timers.removeValue(forKey: id)
        print("⏱️ TimerService: Timer '\(id)' parado")
    }
    
    /// Para todos os timers
    func pararTodosTimers() {
        timers.values.forEach { $0.cancel() }
        timers.removeAll()
        print("⏱️ TimerService: Todos timers parados")
    }
    
    deinit {
        pararTodosTimers()
        print("🗑️ TimerService deinit")
    }
}