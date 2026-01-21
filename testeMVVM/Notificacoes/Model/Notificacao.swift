//
//  Notificacao.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 20/01/26.
//


import Foundation
import UserNotifications

/// Modelo que representa uma notificação agendada
struct Notificacao: Identifiable, Codable {
    let id: String
    var titulo: String
    var mensagem: String
    var dataAgendamento: Date
    var repetir: RepeticaoNotificacao
    var categoria: CategoriaNotificacao
    var badge: Int?
    var som: String
    var foiEntregue: Bool = false
    
    enum RepeticaoNotificacao: String, Codable, CaseIterable {
        case nunca = "Não repetir"
        case diariamente = "Diariamente"
        case semanalmente = "Semanalmente"
        case mensalmente = "Mensalmente"
        case customizado = "Customizado"
    }
    
    enum CategoriaNotificacao: String, Codable, CaseIterable {
        case lembrete = "Lembrete"
        case alerta = "Alerta"
        case informacao = "Informação"
        case urgente = "Urgente"
        case personalizado = "Personalizado"
        
        var icone: String {
            switch self {
            case .lembrete: return "bell.fill"
            case .alerta: return "exclamationmark.triangle.fill"
            case .informacao: return "info.circle.fill"
            case .urgente: return "light.beacon.max.fill"
            case .personalizado: return "star.fill"
            }
        }
        
        var cor: String {
            switch self {
            case .lembrete: return "azul"
            case .alerta: return "laranja"
            case .informacao: return "verde"
            case .urgente: return "vermelho"
            case .personalizado: return "roxo"
            }
        }
    }
    
    // Computed property para status
    var status: String {
        if foiEntregue {
            return "Entregue"
        } else if dataAgendamento > Date() {
            return "Agendada"
        } else {
            return "Expirada"
        }
    }
    
    var estaAtiva: Bool {
        return !foiEntregue && dataAgendamento > Date()
    }
}
