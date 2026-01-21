//
//  EmojiBoardViewModel.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 21/01/26.
//


import Foundation
import SwiftUI
import Combine

/// ViewModel que gerencia o estado do quadro de emojis
class EmojiBoardViewModel: ObservableObject {
    // MARK: - Dados Publicados (o que a View observa)
    @Published var emojis: [Emoji] = []  // Lista de emojis no quadro
    @Published var emojiSelecionado: Emoji?  // Emoji atualmente selecionado
    @Published var emojiParaAdicionar: String = "😀"  // Emoji que será adicionado
    
    // MARK: - Emojis Disponíveis
    let emojisDisponiveis = ["😀", "😂", "🥰", "😎", "🤖", "🐱", "🐶", "🐼", "🦄", "🌈", "🎮", "🚀", "⭐️", "🎨", "❤️"]
    
    // MARK: - Métodos Públicos
    
    /// Adiciona um novo emoji ao quadro
    func adicionarEmoji(_ emojiTexto: String, naPosicao posicao: CGPoint = .zero) {
        print("➕ Adicionando emoji: \(emojiTexto)")
        
        let novoEmoji = Emoji(
            texto: emojiTexto,
            posicao: posicao,
            tamanho: 60,  // Tamanho padrão
            rotacao: Double.random(in: -15...15)  // Rotação aleatória
        )
        
        // Adiciona à lista
        emojis.append(novoEmoji)
        print("✅ Emoji adicionado. Total: \(emojis.count)")
    }
    
    /// Remove um emoji pelo ID
    func removerEmoji(id: UUID) {
        print("🗑️ Removendo emoji com ID: \(id)")
        emojis.removeAll { $0.id == id }
        print("✅ Emoji removido. Total: \(emojis.count)")
    }
    
    /// Atualiza a posição de um emoji
    func atualizarPosicao(doEmojiId id: UUID, para novaPosicao: CGPoint) {
        // Encontra o índice do emoji
        if let index = emojis.firstIndex(where: { $0.id == id }) {
            // Atualiza a posição
            emojis[index].posicao = novaPosicao
             print("📍 Emoji movido para: (\(novaPosicao.x), \(novaPosicao.y))")
        }
    }
    
    /// Aumenta o tamanho de um emoji
    func aumentarTamanho(doEmojiId id: UUID) {
        if let index = emojis.firstIndex(where: { $0.id == id }) {
            emojis[index].tamanho += 110
            print("🔍 Aumentando emoji: \(emojis[index].texto)")
        }
    }
    
    /// Diminui o tamanho de um emoji
    func diminuirTamanho(doEmojiId id: UUID) {
        if let index = emojis.firstIndex(where: { $0.id == id }) {
            emojis[index].tamanho = max(20, emojis[index].tamanho - 110)  // Mínimo 20
            print("🔍 Diminuindo emoji: \(emojis[index].texto)")
        }
    }
    
    /// Rotaciona um emoji
    func rotacionarEmoji(id: UUID, angulo: Double) {
        if let index = emojis.firstIndex(where: { $0.id == id }) {
            emojis[index].rotacao += angulo
            print("🔄 Rotacionando emoji: \(emojis[index].texto) (\(angulo)°)")
        }
    }
    
    /// Seleciona um emoji (para destacá-lo)
    func selecionarEmoji(_ emoji: Emoji?) {
        emojiSelecionado = emoji
        if let emoji = emoji {
            print("👉 Emoji selecionado: \(emoji.texto)")
        } else {
            print("👈 Nenhum emoji selecionado")
        }
    }
    
    /// Limpa todos os emojis do quadro
    func limparQuadro() {
        print("🧹 Limpando quadro...")
        emojis.removeAll()
        emojiSelecionado = nil
        print("✅ Quadro limpo")
    }
    
    /// Gera uma posição aleatória na tela
    func posicaoAleatoria(naTela tamanhoTela: CGSize) -> CGPoint {
        let x = CGFloat.random(in: 50...(tamanhoTela.width - 50))
        let y = CGFloat.random(in: 100...(tamanhoTela.height - 100))
        return CGPoint(x: x, y: y)
    }
}
