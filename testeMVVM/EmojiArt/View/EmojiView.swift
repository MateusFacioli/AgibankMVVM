//
//  EmojiView.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 21/01/26.
//


import SwiftUI

struct EmojiView: View {
    // MARK: - Propriedades
    let emoji: Emoji
    let estaSelecionado: Bool
    let onArrastar: (CGPoint) -> Void
    let onToque: () -> Void
    let onAumentar: () -> Void
    let onDiminuir: () -> Void
    let onGirar: () -> Void
    let onRemover: () -> Void
    
    // MARK: - Estado para arrasto
    @State private var offset: CGSize = .zero
    @State private var isArrastando = false
    @State private var mostrarControles = false
    
    var body: some View {
        ZStack {
            // MARK: - Fundo do Emoji (aparece quando selecionado)
            if estaSelecionado {
                Circle()
                    .fill(emoji.cor.opacity(0.3))
                    .frame(width: emoji.tamanho + 40, height: emoji.tamanho + 40)
                    .shadow(color: emoji.cor, radius: 10)
            }
            
            // MARK: - Emoji Principal
            Text(emoji.texto)
                .font(.system(size: emoji.tamanho))
                .rotationEffect(.degrees(emoji.rotacao))
                .scaleEffect(isArrastando ? 1.2 : 1.0)  // Aumenta quando arrastando
                .animation(.spring(), value: isArrastando)
                .gesture(
                    // MARK: - Gestos do Emoji
                    DragGesture()
                        .onChanged { valor in
                            isArrastando = true
                            
                            // Atualiza a posição temporária
                            offset = valor.translation
                            
                            // Posição atual = posição inicial + arrasto
                            let novaPosicao = CGPoint(
                                x: emoji.posicao.x + offset.width,
                                y: emoji.posicao.y + offset.height
                            )
                            
                            // Notifica a View pai da nova posição
                            onArrastar(novaPosicao)
                        }
                        .onEnded { _ in
                            isArrastando = false
                            offset = .zero  // Reseta o offset após soltar
                        }
                )
                .onTapGesture(count: 1) {
                    // Toque simples: seleciona o emoji
                    withAnimation {
                        onToque()
                    }
                }
                .onLongPressGesture {
                    // Pressão longa: mostra controles
                    withAnimation {
                        mostrarControles = true
                    }
                }
        }
        .overlay(
            // MARK: - Controles (aparecem quando selecionado)
            Group {
                if estaSelecionado && mostrarControles {
                    VStack(spacing: 5) {
                        // Botão de aumentar
                        ControleButton(
                            icone: "plus.circle.fill",
                            cor: .green,
                            acao: onAumentar
                        )
                        
                        // Botão de diminuir
                        ControleButton(
                            icone: "minus.circle.fill",
                            cor: .blue,
                            acao: onDiminuir
                        )
                        
                        // Botão de girar
                        ControleButton(
                            icone: "rotate.right.fill",
                            cor: .orange,
                            acao: onGirar
                        )
                        
                        // Botão de remover
                        ControleButton(
                            icone: "xmark.circle.fill",
                            cor: .red,
                            acao: onRemover
                        )
                    }
                    .padding(5)
                    .background(.ultraThinMaterial)
                    .cornerRadius(10)
                    .offset(x: emoji.tamanho/2 + 30, y: 0)
                }
            }
        )
        .onTapGesture {
            // Toque fora dos controles: esconde-os
            if mostrarControles {
                withAnimation {
                    mostrarControles = false
                }
            }
        }
    }
}

// MARK: - Componente: Botão de Controle
struct ControleButton: View {
    let icone: String
    let cor: Color
    let acao: () -> Void
    
    var body: some View {
        Button(action: acao) {
            Image(systemName: icone)
                .font(.system(size: 20))
                .foregroundColor(cor)
                .frame(width: 30, height: 30)
                .background(Color.white.opacity(0.9))
                .clipShape(Circle())
                .shadow(radius: 2)
        }
    }
}
