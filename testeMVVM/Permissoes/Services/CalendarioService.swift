//
//  CalendarioService.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 18/01/26.
//


import Foundation
internal import EventKit
import Combine

class CalendarioService {
    private let eventStore = EKEventStore()
    
    // Singleton para facilitar o acesso
    static let shared = CalendarioService()
    private init() {}
    
    // Verifica o status atual da permissão
    func verificarStatusPermissao() -> EKAuthorizationStatus {
        print(" minha permissão é:\(EKEventStore.authorizationStatus(for: .event).rawValue)")
        return EKEventStore.authorizationStatus(for: .event)
    }
    
    // Solicita permissão ao usuário
    func solicitarPermissao() -> Future<Bool, Error> {
        return Future { promise in
            if #available(iOS 17.0, *) {
                // iOS 17+ - Método moderno
                self.eventStore.requestFullAccessToEvents { granted, error in
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        promise(.success(granted))
                    }
                }
            } else {
                // Versões anteriores ao iOS 17
                self.eventStore.requestAccess(to: .event) { granted, error in
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        promise(.success(granted))
                    }
                }
            }
        }
    }
    
    // Cria um evento no calendário
    func criarEvento(_ evento: Evento) -> Result<Void, Error> {
        let status = verificarStatusPermissao()
        
        switch status {
        case .authorized, .fullAccess:
            let ekEvent = evento.toEKEvent(store: eventStore)
            
            do {
                try eventStore.save(ekEvent, span: .thisEvent)
                return .success(())
            } catch {
                return .failure(error)
            }
            
        case .denied, .restricted:
            return .failure(NSError(domain: "Permissao negada", code: 403))
            
        case .notDetermined:
            return .failure(NSError(domain: "Permissão não solicitada", code: 401))
            
        @unknown default:
            return .failure(NSError(domain: "Status desconhecido", code: 500))
        }
    }
    
    // Lista eventos futuros (opcional - para demonstrar funcionalidade)
    func listarEventosFuturos(limite: Int = 10) -> [EKEvent] {
        let status = verificarStatusPermissao()
        
        guard status == .authorized || status == .fullAccess else {
            return []
        }
        
        let calendario = Calendar.current
        let dataInicio = Date()
        var componentes = DateComponents()
        componentes.month = 1
        guard let dataFim = calendario.date(byAdding: componentes, to: dataInicio) else {
            return []
        }
        
        let predicate = eventStore.predicateForEvents(
            withStart: dataInicio,
            end: dataFim,
            calendars: nil
        )
        
        return eventStore.events(matching: predicate).prefix(limite).map { $0 }
    }
}
