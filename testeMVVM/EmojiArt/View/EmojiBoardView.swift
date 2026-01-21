//
//  EmojiBoardView.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 21/01/26.
//


import SwiftUI

struct EmojiBoardView: View {
    // MARK: - ViewModel (recebido da View pai)
    @ObservedObject var viewModel: EmojiBoardViewModel
    
    // MARK: - Estado para tamanho da tela
    @State private var tamanhoQuadro: CGSize = .zero
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // MARK: - Quadro Branco (área de trabalho)
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.9))
                    .shadow(radius: 10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                    )
                    .onAppear {
                        // Guarda o tamanho do quadro para referência
                        tamanhoQuadro = geometry.size
                        print("📐 Tamanho do quadro: \(tamanhoQuadro)")
                    }
                
                // MARK: - Grid de Referência (opcional, ajuda no posicionamento)
                if viewModel.emojis.isEmpty {
                    GridView()
                }
                
                // MARK: - Todos os Emojis
                ForEach(viewModel.emojis) { emoji in
                    EmojiView(
                        emoji: emoji,
                        estaSelecionado: viewModel.emojiSelecionado?.id == emoji.id,
                        onArrastar: { novaPosicao in
                            // Quando o emoji é arrastado, atualiza no ViewModel
                            viewModel.atualizarPosicao(doEmojiId: emoji.id, para: novaPosicao)
                        },
                        onToque: {
                            // Quando o emoji é tocado, seleciona/desmarca
                            if viewModel.emojiSelecionado?.id == emoji.id {
                                viewModel.selecionarEmoji(nil)
                            } else {
                                viewModel.selecionarEmoji(emoji)
                            }
                        },
                        onAumentar: {
                            viewModel.aumentarTamanho(doEmojiId: emoji.id)
                        },
                        onDiminuir: {
                            viewModel.diminuirTamanho(doEmojiId: emoji.id)
                        },
                        onGirar: {
                            viewModel.rotacionarEmoji(id: emoji.id, angulo: 45)
                        },
                        onRemover: {
                            viewModel.removerEmoji(id: emoji.id)
                        }
                    )
                    .position(emoji.posicao)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .padding()
    }
}

// MARK: - Componente: Grid de Referência
struct GridView: View {
    var body: some View {
        ZStack {
            // Linhas horizontais
            ForEach(0..<10) { i in
                Path { path in
                    let y = CGFloat(i) * 50
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: 400, y: y))
                }
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            }
            
            // Linhas verticais
            ForEach(0..<8) { i in
                Path { path in
                    let x = CGFloat(i) * 50
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: 500))
                }
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            }
        }
        .opacity(0.5)
    }
}