//
//  EtapaCiclo.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 20/01/26.
//


import Foundation
import SwiftUI

/// Modelo que representa uma etapa do ciclo de vida
struct EtapaCiclo: Identifiable, Codable {
    let id = UUID()
    let nome: String
    let descricao: String
    let momento: MomentoCiclo
    let cor: String
    let icone: String
    let ordem: Int
    
    var corSwiftUI: Color {
        switch cor {
        case "azul": return .blue
        case "verde": return .green
        case "laranja": return .orange
        case "roxo": return .purple
        case "vermelho": return .red
        default: return .gray
        }
    }
    
    enum MomentoCiclo: String, Codable {
        case inicializacao = "Inicialização"
        case aparecimento = "Aparecimento"
        case desaparecimento = "Desaparecimento"
        case destruicao = "Destruição"
        case background = "Background/Foreground"
    }
}
