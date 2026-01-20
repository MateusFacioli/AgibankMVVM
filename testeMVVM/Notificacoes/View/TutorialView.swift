//
//  TutorialView.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 20/01/26.
//


import SwiftUI

struct TutorialView: View {
    @Environment(\.dismiss) var dismiss
    @State private var paginaAtual = 0
    
    let paginas = [
        TutorialPagina(
            titulo: "Bem-vindo ao App de Notificações!",
            descricao: "Aprenda sobre notificações locais e badges na bandeja do app.",
            icone: "bell.badge.fill",
            cor: .blue
        ),
        TutorialPagina(
            titulo: "Permissões",
            descricao: "O app precisa da sua permissão para enviar notificações. Isso é controlado pelo iOS para sua privacidade.",
            icone: "lock.shield",
            cor: .green
        ),
        TutorialPagina(
            titulo: "Badge na Bandeja",
            descricao: "O número vermelho na bandeja do app mostra quantas notificações pendentes você tem.",
            icone: "app.badge.fill",
            cor: .red
        ),
        TutorialPagina(
            titulo: "Agendamento",
            descricao: "Você pode agendar notificações para datas futuras e configurar repetições.",
            icone: "calendar.badge.clock",
            cor: .orange
        ),
        TutorialPagina(
            titulo: "Categorias e Ações",
            descricao: "Notificações podem ter categorias diferentes e ações customizadas para o usuário responder.",
            icone: "list.bullet",
            cor: .purple
        ),
        TutorialPagina(
            titulo: "Pronto para Começar!",
            descricao: "Explore todas as funcionalidades e aprenda como o sistema de notificações funciona no iOS.",
            icone: "checkmark.circle.fill",
            cor: .green
        )
    ]
    
    var body: some View {
        VStack {
            // MARK: - Conteúdo
            TabView(selection: $paginaAtual) {
                ForEach(0..<paginas.count, id: \.self) { index in
                    VStack(spacing: 30) {
                        Spacer()
                        
                        Image(systemName: paginas[index].icone)
                            .font(.system(size: 70))
                            .foregroundColor(paginas[index].cor)
                        
                        Text(paginas[index].titulo)
                            .font(.title2)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                        
                        Text(paginas[index].descricao)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)
                        
                        Spacer()
                        
                        // Indicadores de página
                        HStack(spacing: 8) {
                            ForEach(0..<paginas.count, id: \.self) { i in
                                Circle()
                                    .fill(i == paginaAtual ? paginas[index].cor : Color.gray.opacity(0.3))
                                    .frame(width: 8, height: 8)
                            }
                        }
                        .padding(.bottom, 20)
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            // MARK: - Botões de Navegação
            HStack {
                if paginaAtual > 0 {
                    Button("Anterior") {
                        withAnimation {
                            paginaAtual -= 1
                        }
                    }
                    .buttonStyle(.bordered)
                }
                
                Spacer()
                
                if paginaAtual < paginas.count - 1 {
                    Button("Próximo") {
                        withAnimation {
                            paginaAtual += 1
                        }
                    }
                    .buttonStyle(.borderedProminent)
                } else {
                    Button("Começar") {
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 30)
        }
        .onAppear {
            print("🟢 TutorialView onAppear()")
        }
        .onDisappear {
            print("🔴 TutorialView onDisappear()")
        }
    }
}

struct TutorialPagina {
    let titulo: String
    let descricao: String
    let icone: String
    let cor: Color
}