//
//  NotificacaoCardView.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 20/01/26.
//


import SwiftUI

struct NotificacaoCardView: View {
    let notificacao: Notificacao
    @State private var pulsar = false
    
    var body: some View {
        HStack(spacing: 15) {
            // Ícone com animação
            ZStack {
                Circle()
                    .fill(corParaCategoria(notificacao.categoria).opacity(0.2))
                    .frame(width: 50, height: 50)
                    .scaleEffect(pulsar ? 1.1 : 1.0)
                    .animation(
                        Animation.easeInOut(duration: 1.5)
                            .repeatForever(autoreverses: true),
                        value: pulsar
                    )
                
                Image(systemName: notificacao.categoria.icone)
                    .font(.title3)
                    .foregroundColor(corParaCategoria(notificacao.categoria))
            }
            .onAppear {
                pulsar = notificacao.estaAtiva
            }
            
            // Conteúdo
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(notificacao.titulo)
                        .font(.headline)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    if notificacao.estaAtiva {
                        Text("●")
                            .font(.caption)
                            .foregroundColor(.green)
                    }
                }
                
                Text(notificacao.mensagem)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                HStack {
                    Text(formatarData(notificacao.dataAgendamento))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    if let badge = notificacao.badge, badge > 0 {
                        BadgeMiniView(count: badge)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
    }
    
    private func formatarData(_ date: Date) -> String {
        let formatter = DateFormatter()
        
        if Calendar.current.isDateInToday(date) {
            formatter.dateFormat = "'Hoje' HH:mm"
        } else if Calendar.current.isDateInTomorrow(date) {
            formatter.dateFormat = "'Amanhã' HH:mm"
        } else {
            formatter.dateFormat = "dd/MM HH:mm"
        }
        
        return formatter.string(from: date)
    }
    
    private func corParaCategoria(_ categoria: Notificacao.CategoriaNotificacao) -> Color {
        switch categoria.cor {
        case "azul": return .blue
        case "laranja": return .orange
        case "verde": return .green
        case "vermelho": return .red
        case "roxo": return .purple
        default: return .gray
        }
    }
}

struct BadgeMiniView: View {
    let count: Int
    
    var body: some View {
        Text("\(count)")
            .font(.system(size: 11, weight: .bold))
            .foregroundColor(.white)
            .frame(width: 20, height: 20)
            .background(Color.red)
            .clipShape(Circle())
    }
}