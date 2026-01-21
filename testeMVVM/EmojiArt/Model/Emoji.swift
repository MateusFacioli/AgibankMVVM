//
//  Emoji.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 21/01/26.
//


import Foundation
import SwiftUI

/// Modelo que representa um emoji na tela
struct Emoji: Identifiable {
    let id = UUID()  // ID único para cada emoji
    let texto: String  // O emoji em si (ex: "😀")
    var posicao: CGPoint  // Posição na tela (x, y)
    var tamanho: CGFloat  // Tamanho do emoji
    var rotacao: Double  // Rotação em graus
    var cor: Color  // Cor de fundo (opcional)
    
    /// Inicializador com valores padrão
    init(texto: String, posicao: CGPoint = .zero, tamanho: CGFloat = 60, rotacao: Double = 0) {
        self.texto = texto
        self.posicao = posicao
        self.tamanho = tamanho
        self.rotacao = rotacao
        self.cor = Color.random()  // Cor aleatória
    }
}

/// Extensão para gerar cores aleatórias
extension Color {
    static func random() -> Color {
        let cores: [Color] = [
            .red, .blue, .green, .orange, .purple, 
            .pink, .yellow, .cyan, .mint, .indigo
        ]
        return cores.randomElement() ?? .blue
    }
}

/// Extensão para ponto CGPoint
extension CGPoint {
    /// Distância entre dois pontos
    func distancia(para outroPonto: CGPoint) -> CGFloat {
        return sqrt(pow(x - outroPonto.x, 2) + pow(y - outroPonto.y, 2))
    }
}