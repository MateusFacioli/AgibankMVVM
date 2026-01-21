//
//  ConfiguracoesNotificationView.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 20/01/26.
//


import SwiftUI

struct ConfiguracoesNotificationView: View {
    @ObservedObject var permissaoVM: PermissaoViewModel
    @ObservedObject var notificacaoVM: NotificacaoViewModel
    @AppStorage("somNotificacao") private var somNotificacao = "default"
    @AppStorage("vibrarNotificacao") private var vibrarNotificacao = true
    @AppStorage("autoBadge") private var autoBadge = true
    @State private var mostrarConfirmacaoLimpeza = false
    
    let sonsDisponiveis = ["default", "alert", "chime", "echo", "harp", "bell", "message"]
    
    // MARK: - Init (Ciclo de Vida)
    init(permissaoVM: PermissaoViewModel, notificacaoVM: NotificacaoViewModel) {
        self.permissaoVM = permissaoVM
        self.notificacaoVM = notificacaoVM
        print("🔵 ConfiguracoesView init() - Carregando configurações")
    }
    
    var body: some View {
        NavigationStack {
            Form {
                // MARK: - Seção: Permissões
                Section("Permissões do Sistema") {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Status das Notificações")
                                .font(.subheadline)
                            Text(permissaoVM.mensagemStatus)
                                .font(.caption)
                                .foregroundColor(statusCor)
                        }
                        
                        Spacer()
                        
                        if permissaoVM.statusPermissao != .authorized {
                            Button("Solicitar") {
                                permissaoVM.solicitarPermissao()
                            }
                            .buttonStyle(.bordered)
                            .disabled(permissaoVM.estaSolicitando)
                        }
                    }
                    
                    Button("Abrir Configurações do Sistema") {
                        permissaoVM.abrirConfiguracoes()
                    }
                    .foregroundColor(.blue)
                }
                
                // MARK: - Seção: Notificações
                Section("Configurações de Notificação") {
                    Toggle("Sons", isOn: $vibrarNotificacao)
                        .onChange(of: vibrarNotificacao) { valorAntigo, valorNovo in
                            print("🔊 Som alterado: \(valorAntigo) → \(valorNovo)")
                            notificacaoVM.configuracoes.vibrar = valorNovo
                        }
                    
                    Toggle("Badge Automático", isOn: $autoBadge)
                        .onChange(of: autoBadge) { valorAntigo, valorNovo in
                            print("🔢 Auto-badge alterado: \(valorAntigo) → \(valorNovo)")
                            notificacaoVM.configuracoes.mostrarBadge = valorNovo
                        }
                    
                    Picker("Som Padrão", selection: $somNotificacao) {
                        ForEach(sonsDisponiveis, id: \.self) { som in
                            Text(som.capitalized).tag(som)
                        }
                    }
                    .onChange(of: somNotificacao) { valorAntigo, valorNovo in
                        print("🎵 Som padrão alterado: \(valorAntigo) → \(valorNovo)")
                        notificacaoVM.configuracoes.somPadrao = valorNovo
                    }
                }
                
                // MARK: - Seção: Badge
                Section("Controle de Badge") {
                    Stepper(
                        "Badge Atual: \(notificacaoVM.badgeCount)",
                        value: $notificacaoVM.badgeCount,
                        in: 0...99
                    )
                    .onChange(of: notificacaoVM.badgeCount) { valorAntigo, valorNovo in
                        print("🔢 Badge alterado via stepper: \(valorAntigo) → \(valorNovo)")
                        notificacaoVM.atualizarBadgeCount(valorNovo)
                    }
                    
                    Button("Zerar Badge") {
                        notificacaoVM.limparBadge()
                    }
                    .foregroundColor(.orange)
                    .disabled(notificacaoVM.badgeCount == 0)
                    
                    Button("Testar Badge +1") {
                        notificacaoVM.atualizarBadgeCount(notificacaoVM.badgeCount + 1)
                    }
                    .foregroundColor(.green)
                }
                
                // MARK: - Seção: Ações
                Section("Ações") {
                    Button {
                        notificacaoVM.enviarNotificacaoTeste()
                    } label: {
                        Label("Enviar Notificação de Teste", systemImage: "bolt.fill")
                    }
                    .foregroundColor(.blue)
                    
                    Button(role: .destructive) {
                        mostrarConfirmacaoLimpeza = true
                    } label: {
                        Label("Cancelar Todas Notificações", systemImage: "trash")
                    }
                    
                    Button {
                        exportarDados()
                    } label: {
                        Label("Exportar Dados", systemImage: "square.and.arrow.up")
                    }
                    .foregroundColor(.green)
                }
                
                // MARK: - Seção: Sobre
                Section("Sobre o App") {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image(systemName: "bell.badge.fill")
                                .font(.title2)
                                .foregroundColor(.blue)
                            Text("Notificações & Badge")
                                .font(.headline)
                        }
                        
                        Text("Versão 1.0.0")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("Projeto didático para ensino de:")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("• UserNotifications Framework")
                                .font(.caption2)
                            Text("• Badges na bandeja do app")
                                .font(.caption2)
                            Text("• Arquitetura MVVM com SwiftUI")
                                .font(.caption2)
                            Text("• Ciclo de vida de apps iOS")
                                .font(.caption2)
                        }
                        .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 5)
                }
            }
            .navigationTitle("Configurações")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Limpar Tudo", isPresented: $mostrarConfirmacaoLimpeza) {
                Button("Cancelar", role: .cancel) { }
                Button("Confirmar", role: .destructive) {
                    notificacaoVM.cancelarTodasNotificacoes()
                }
            } message: {
                Text("Isso cancelará todas as notificações agendadas e limpará o histórico. Esta ação não pode ser desfeita.")
            }
        }
        .onAppear {
            print("🟢 ConfiguracoesView onAppear()")
        }
        .onDisappear {
            print("🔴 ConfiguracoesView onDisappear()")
        }
    }
    
    // MARK: - Private Methods
    
    private var statusCor: Color {
        switch permissaoVM.statusPermissao {
        case .notDetermined: return .orange
        case .denied: return .red
        case .authorized: return .green
        case .provisional: return .blue
        case .ephemeral: return .purple
        @unknown default: return .gray
        }
    }
    
    private func exportarDados() {
        print("📤 Exportando dados do app")
        
        let dados = """
        === DADOS DO APP ===
        Data: \(Date())
        
        PERMISSÕES:
        - Status: \(permissaoVM.mensagemStatus)
        
        ESTATÍSTICAS:
        - Total notificações: \(notificacaoVM.notificacoes.count)
        - Notificações ativas: \(notificacaoVM.notificacoesAtivas.count)
        - Badge atual: \(notificacaoVM.badgeCount)
        
        CONFIGURAÇÕES:
        - Som: \(somNotificacao)
        - Vibrar: \(vibrarNotificacao)
        - Auto-badge: \(autoBadge)
        """
        
        // Aqui você implementaria o compartilhamento dos dados
        print("✅ Dados prontos para exportação")
    }
}

struct InfoNotificationRow: View {
    let icone: String
    let titulo: String
    let valor: String
    
    var body: some View {
        HStack {
            Image(systemName: icone)
                .foregroundColor(.blue)
                .frame(width: 30)
            
            Text(titulo)
            
            Spacer()
            
            Text(valor)
                .font(.callout)
                .foregroundColor(.secondary)
        }
    }
}
