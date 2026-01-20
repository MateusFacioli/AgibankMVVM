//
//  PainelNotificacoesView.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 20/01/26.
//


import SwiftUI

struct PainelNotificacoesView: View {
    @ObservedObject var permissaoVM: PermissaoViewModel
    @ObservedObject var notificacaoVM: NotificacaoViewModel
    @State private var mostrarTutorial = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // MARK: - Header com Status
                    VStack(spacing: 15) {
                        Image(systemName: permissaoIcon)
                            .font(.system(size: 60))
                            .foregroundColor(permissaoCor)
                        
                        Text("Notificações")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text(permissaoVM.mensagemStatus)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)
                    }
                    .padding(.top)
                    
                    // MARK: - Card de Permissão
                    if permissaoVM.statusPermissao != .authorized {
                        VStack(spacing: 15) {
                            Text("Permissão Necessária")
                                .font(.headline)
                            
                            Text("Para enviar notificações e mostrar badges, precisamos da sua permissão.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                            
                            if permissaoVM.statusPermissao == .denied {
                                Button("Abrir Configurações") {
                                    permissaoVM.abrirConfiguracoes()
                                }
                                .buttonStyle(.borderedProminent)
                            } else {
                                Button("Solicitar Permissão") {
                                    permissaoVM.solicitarPermissao()
                                }
                                .buttonStyle(.borderedProminent)
                                .disabled(permissaoVM.estaSolicitando)
                            }
                        }
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                    
                    // MARK: - Badge Counter
                    BadgeCounterView(badgeCount: notificacaoVM.badgeCount)
                        .padding(.horizontal)
                    
                    // MARK: - Estatísticas
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                        StatCard(
                            titulo: "Agendadas",
                            valor: "\(notificacaoVM.notificacoesAtivas.count)",
                            cor: .green,
                            icone: "calendar.badge.clock"
                        )
                        
                        StatCard(
                            titulo: "Total",
                            valor: "\(notificacaoVM.notificacoes.count)",
                            cor: .blue,
                            icone: "list.bullet"
                        )
                        
                        StatCard(
                            titulo: "Entregues",
                            valor: "\(notificacaoVM.notificacoes.filter { $0.foiEntregue }.count)",
                            cor: .orange,
                            icone: "checkmark.circle.fill"
                        )
                        
                        StatCard(
                            titulo: "Última",
                            valor: ultimaNotificacaoTexto,
                            cor: .purple,
                            icone: "clock.fill"
                        )
                    }
                    .padding(.horizontal)
                    
                    // MARK: - Ações Rápidas
                    VStack(spacing: 15) {
                        Text("Ações Rápidas")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                        
                        HStack(spacing: 10) {
                            Button {
                                notificacaoVM.enviarNotificacaoTeste()
                            } label: {
                                Label("Testar", systemImage: "bolt.fill")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)
                            .disabled(!permissaoConcedida)
                            
                            Button {
                                notificacaoVM.limparBadge()
                            } label: {
                                Label("Limpar Badge", systemImage: "0.circle")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.bordered)
                            .tint(.orange)
                            .disabled(!permissaoConcedida)
                        }
                        .padding(.horizontal)
                    }
                    
                    // MARK: - Notificações Ativas
                    if !notificacaoVM.notificacoesAtivas.isEmpty {
                        VStack(spacing: 15) {
                            Text("Próximas Notificações")
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                            
                            ForEach(notificacaoVM.notificacoesAtivas.prefix(3)) { notificacao in
                                NotificacaoCardView(notificacao: notificacao)
                                    .padding(.horizontal)
                            }
                            
                            if notificacaoVM.notificacoesAtivas.count > 3 {
                                NavigationLink {
                                    HistoricoView(notificacaoVM: notificacaoVM)
                                } label: {
                                    Text("Ver todas (\(notificacaoVM.notificacoesAtivas.count))")
                                        .font(.caption)
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    } else if permissaoConcedida {
                        VStack(spacing: 15) {
                            Image(systemName: "bell.slash")
                                .font(.system(size: 40))
                                .foregroundColor(.gray)
                            
                            Text("Nenhuma notificação agendada")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            Text("Crie sua primeira notificação usando o botão abaixo")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                    
                    Spacer(minLength: 20)
                }
            }
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        mostrarTutorial = true
                    } label: {
                        Image(systemName: "questionmark.circle")
                    }
                }
            }
            .sheet(isPresented: $mostrarTutorial) {
                TutorialView()
            }
        }
        .onAppear {
            print("🟢 PainelNotificacoesView onAppear()")
        }
        .onDisappear {
            print("🔴 PainelNotificacoesView onDisappear()")
        }
    }
    
    // MARK: - Computed Properties
    
    private var permissaoConcedida: Bool {
        permissaoVM.statusPermissao == .authorized
    }
    
    private var permissaoIcon: String {
        switch permissaoVM.statusPermissao {
        case .notDetermined: return "questionmark.circle"
        case .denied: return "xmark.circle"
        case .authorized: return "checkmark.circle"
        case .provisional: return "exclamationmark.circle"
        case .ephemeral: return "timer"
        @unknown default: return "exclamationmark.triangle"
        }
    }
    
    private var permissaoCor: Color {
        switch permissaoVM.statusPermissao {
        case .notDetermined: return .gray
        case .denied: return .red
        case .authorized: return .green
        case .provisional: return .orange
        case .ephemeral: return .blue
        @unknown default: return .orange
        }
    }
    
    private var ultimaNotificacaoTexto: String {
        if let ultima = notificacaoVM.ultimaNotificacao {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            return formatter.string(from: ultima)
        }
        return "Nenhuma"
    }
}

struct StatCard: View {
    let titulo: String
    let valor: String
    let cor: Color
    let icone: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icone)
                .font(.title2)
                .foregroundColor(cor)
            
            Text(titulo)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(valor)
                .font(.system(.body, design: .monospaced))
                .fontWeight(.semibold)
        }
        .frame(maxWidth: .infinity, minHeight: 100)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(cor.opacity(0.3), lineWidth: 1)
        )
    }
}