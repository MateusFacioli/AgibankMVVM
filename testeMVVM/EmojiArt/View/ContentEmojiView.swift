//
//  ContentEmojiView.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 21/01/26.
//


import SwiftUI

struct ContentEmojiView: View {
    // MARK: - ViewModel (gerencia o estado)
    @StateObject private var viewModel = EmojiBoardViewModel()
    
    // MARK: - Estado Local
    @State private var mostrarPaleta = false
    
    var body: some View {
        ZStack {
            // MARK: - Plano de Fundo
            LinearGradient(
                colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // MARK: - Quadro Principal
            EmojiBoardView(viewModel: viewModel)
            
            VStack {
                Spacer()
                
                // MARK: - Barra de Controles
                HStack {
                    // Botão para adicionar emoji aleatório
                    Button {
                        adicionarEmojiAleatorio()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.blue)
                    }
                    
                    Spacer()
                    
                    // Botão para mostrar/ocultar paleta
                    Button {
                        withAnimation {
                            mostrarPaleta.toggle()
                        }
                    } label: {
                        Image(systemName: "face.smiling.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.orange)
                    }
                    
                    Spacer()
                    
                    // Botão para limpar quadro
                    Button {
                        viewModel.limparQuadro()
                    } label: {
                        Image(systemName: "trash.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.red)
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(15)
                .padding(.horizontal)
                .padding(.bottom, 20)
                
                // MARK: - Paleta de Emojis (aparece quando aberta)
                if mostrarPaleta {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(viewModel.emojisDisponiveis, id: \.self) { emoji in
                                Button {
                                    // Adiciona o emoji clicado no centro
                                    viewModel.adicionarEmoji(emoji, naPosicao: CGPoint(x: 200, y: 400))
                                } label: {
                                    Text(emoji)
                                        .font(.system(size: 40))
                                        .padding(10)
                                        .background(Color.white.opacity(0.8))
                                        .cornerRadius(10)
                                        .shadow(radius: 2)
                                }
                            }
                        }
                        .padding()
                    }
                    .frame(height: 80)
                    .background(.ultraThinMaterial)
                    .cornerRadius(15)
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                    .transition(.move(edge: .bottom))
                }
            }
            
            // MARK: - Indicador de Status
            VStack {
                HStack {
                    Text("Emojis: \(viewModel.emojis.count)")
                        .font(.caption)
                        .padding(8)
                        .background(.ultraThinMaterial)
                        .cornerRadius(10)
                    
                    if let selecionado = viewModel.emojiSelecionado {
                        Text("Selecionado: \(selecionado.texto)")
                            .font(.caption)
                            .padding(8)
                            .background(.ultraThinMaterial)
                            .cornerRadius(10)
                    }
                }
                .padding(.top)
                
                Spacer()
            }
        }
    }
    
    // MARK: - Métodos Privados
    
    private func adicionarEmojiAleatorio() {
        guard let emoji = viewModel.emojisDisponiveis.randomElement() else { return }
        viewModel.adicionarEmoji(emoji)
    }
}

// MARK: - Preview (para ver no Xcode)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentEmojiView()
    }
}
