//
//  Log.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 20/01/26.
//


import Foundation

/// Modelo para registrar eventos do ciclo de vida
struct Log: Identifiable, Codable {
    let id = UUID()
    let timestamp: Date
    let evento: String
    let descricao: String
    let view: String
    let cor: LogCor
    let icone: String
    
    enum LogCor: String, Codable {
        case info, warning, error, success
        
        var colorName: String {
            switch self {
            case .info: return "blue"
            case .warning: return "orange"
            case .error: return "red"
            case .success: return "green"
            }
        }
    }
    
    var timestampFormatado: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        return formatter.string(from: timestamp)
    }
}