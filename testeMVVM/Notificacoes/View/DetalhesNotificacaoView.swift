//
//  DetalhesNotificacaoView.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 20/01/26.
//


import SwiftUI

struct DetalhesNotificacaoView: View {
    let notificacao: Notificacao
    @ObservedObject var notificacaoVM: NotificacaoViewModel
    @Environment(\.dismiss) var dismiss
    @State private var mostrarConfirmacaoCancelamento = false
    
    // MARK: - Init
    init(notificacao: Notificacao, notificacaoVM: NotificacaoViewModel) {
        self.notificacao = notificacao
        self.notificacaoVM = notificacaoVM
        print("🔵 DetalhesNotificacaoView init() - Notificação: \(notificacao.id)")
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // MARK: - Header
                    VStack(spacing: 15) {
                        Image(systemName: notificacao.categoria.icone)
                            .font(.system(size: 60))
                            .foregroundColor(corParaCategoria(notificacao.categoria))
                        
                        Text(notificacao.titulo)
                            .font(.title2)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding(.top)
                    
                    // MARK: - Card de Informações
                    VStack(alignment: .leading, spacing: 15) {
                        InfoItem(icone: "text.bubble.fill", titulo: "Mensagem", valor: notificacao.mensagem)
                        
                        InfoItem(icone: "calendar.badge.clock", titulo: "Data/Hora", valor: dataHoraFormatada)
                        
                        InfoItem(icone: "arrow.clockwise", titulo: "Repetição", valor: notificacao.repetir.rawValue)
                        
                        InfoItem(icone: "tag.fill", titulo: "Categoria", valor: notificacao.categoria.rawValue)
                        
                        InfoItem(icone: "info.circle.fill", titulo: "Status", valor: notificacao.status)
                        
                        if let badge = notificacao.badge {
                            InfoItem(icone: "0.circle.fill", titulo: "Badge", valor: "\(badge)")
                        }
                        
                        InfoItem(icone: "number", titulo: "ID", valor: notificacao.id.prefix(8) + "...")
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.05), radius: 5)
                    .padding(.horizontal)
                    
                    // MARK: - Ações
                    if notificacao.estaAtiva {
                        VStack(spacing: 10) {
                            Button(role: .destructive) {
                                mostrarConfirmacaoCancelamento = true
                            } label: {
                                Label("Cancelar Notificação", systemImage: "xmark.circle.fill")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.red)
                            
                            Button {
                                // Lembrar mais tarde
                                reagendarParaMaisTarde()
                            } label: {
                                Label("Lembrar mais tarde", systemImage: "clock.arrow.circlepath")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.bordered)
                        }
                        .padding(.horizontal)
                    }
                    
                    // MARK: - Informações Técnicas
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Informações Técnicas")
                            .font(.headline)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("• Foi criada: \(tempoDesdeCriacao)")
                                .font(.caption)
                            
                            Text("• Tempo restante: \(tempoRestante)")
                                .font(.caption)
                            
                            Text("• Foi entregue: \(notificacao.foiEntregue ? "Sim" : "Não")")
                                .font(.caption)
                            
                            if notificacao.foiEntregue {
                                Text("• Recebida pelo usuário")
                                    .font(.caption)
                                    .foregroundColor(.green)
                            }
                        }
                        .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    
                    Spacer(minLength: 20)
                }
            }
            .navigationTitle("Detalhes")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Fechar") {
                        dismiss()
                    }
                }
            }
            .alert("Cancelar Notificação", isPresented: $mostrarConfirmacaoCancelamento) {
                Button("Manter", role: .cancel) { }
                Button("Cancelar", role: .destructive) {
                    notificacaoVM.cancelarNotificacao(id: notificacao.id)
                    dismiss()
                }
            } message: {
                Text("Esta notificação será cancelada permanentemente.")
            }
        }
        .onAppear {
            print("🟢 DetalhesNotificacaoView onAppear()")
        }
        .onDisappear {
            print("🔴 DetalhesNotificacaoView onDisappear()")
        }
    }
    
    // MARK: - Computed Properties
    
    private var dataHoraFormatada: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy 'às' HH:mm"
        return formatter.string(from: notificacao.dataAgendamento)
    }
    
    private var tempoDesdeCriacao: String {
        let interval = Date().timeIntervalSince(notificacao.dataAgendamento)
        
        if interval < 0 {
            let minutos = Int(-interval / 60)
            let horas = minutos / 60
            let dias = horas / 24
            
            if dias > 0 {
                return "em \(dias) dia\(dias > 1 ? "s" : "")"
            } else if horas > 0 {
                return "em \(horas) hora\(horas > 1 ? "s" : "")"
            } else {
                return "em \(minutos) minuto\(minutos > 1 ? "s" : "")"
            }
        } else {
            return "há \(Int(interval / 60)) minutos"
        }
    }
    
    private var tempoRestante: String {
        let interval = notificacao.dataAgendamento.timeIntervalSince(Date())
        
        if interval <= 0 {
            return "Já passou"
        }
        
        let minutos = Int(interval / 60)
        let horas = minutos / 60
        let dias = horas / 24
        
        if dias > 0 {
            return "\(dias) dia\(dias > 1 ? "s" : "")"
        } else if horas > 0 {
            return "\(horas) hora\(horas > 1 ? "s" : "")"
        } else {
            return "\(minutos) minuto\(minutos > 1 ? "s" : "")"
        }
    }
    
    // MARK: - Private Methods
    
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
    
    private func reagendarParaMaisTarde() {
        print("⏰ Reagendando notificação para 30 minutos depois")
        
        let novaData = Date().addingTimeInterval(30 * 60) // 30 minutos
        
        notificacaoVM.agendarNotificacao(
            titulo: notificacao.titulo + " (Reagendada)",
            mensagem: notificacao.mensagem,
            data: novaData,
            repetir: .nunca,
            categoria: notificacao.categoria,
            badge: notificacao.badge
        )
        
        // Cancelar a original
        notificacaoVM.cancelarNotificacao(id: notificacao.id)
        
        dismiss()
    }
}

struct InfoItem: View {
    let icone: String
    let titulo: String
    let valor: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icone)
                .foregroundColor(.blue)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(titulo)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(valor)
                    .font(.body)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}