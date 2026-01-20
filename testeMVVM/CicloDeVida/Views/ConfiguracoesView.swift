//
//  ConfiguracoesView.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 20/01/26.
//


import SwiftUI

struct ConfiguracoesView: View {
    @ObservedObject var viewModel: CicloDeVidaViewModel
    @AppStorage("notificacoesAtivas") private var notificacoesAtivas = true
    @AppStorage("autoRefresh") private var autoRefresh = true
    @AppStorage("logLevel") private var logLevel = 1
    
    var body: some View {
        NavigationStack {
            Form {
                // MARK: - Seção: Sobre
                Section {
                    VStack(spacing: 15) {
                        Image(systemName: "arrow.clockwise.circle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.blue)
                        
                        Text("Ciclo de Vida SwiftUI")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Versão 1.0 - Projeto Didático")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("Este app demonstra o ciclo de vida de Views em SwiftUI usando arquitetura MVVM.")
                            .font(.caption)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                }
                
                // MARK: - Seção: Configurações
                Section("Configurações do App") {
                    Toggle("Notificações do Sistema", isOn: $notificacoesAtivas)
                    
                    Toggle("Auto-refresh dos Logs", isOn: $autoRefresh)
                    
                    Picker("Nível de Log", selection: $logLevel) {
                        Text("Básico").tag(0)
                        Text("Normal").tag(1)
                        Text("Detalhado").tag(2)
                        Text("Debug").tag(3)
                    }
                }
                
                // MARK: - Seção: Estatísticas
                Section("Estatísticas do Sistema") {
                    InfoRow(icone: "arrow.up.circle.fill", 
                           titulo: "Total de Aparições", 
                           valor: "\(viewModel.contadorAparicoes)")
                    
                    InfoRow(icone: "arrow.down.circle.fill", 
                           titulo: "Total de Desaparições", 
                           valor: "\(viewModel.contadorDesaparicoes)")
                    
                    InfoRow(icone: "timer", 
                           titulo: "Tempo Total Visível", 
                           valor: "\(Int(viewModel.tempoVisivel)) segundos")
                    
                    InfoRow(icone: "terminal.fill", 
                           titulo: "Logs Registrados", 
                           valor: "\(viewModel.logs.count)")
                    
                    InfoRow(icone: "app.badge.fill", 
                           titulo: "Fase Atual do App", 
                           valor: faseString(viewModel.faseApp))
                }
                
                // MARK: - Seção: Ações
                Section("Ações") {
                    Button {
                        viewModel.resetarContadores()
                    } label: {
                        Label("Resetar Estatísticas", systemImage: "arrow.counterclockwise")
                    }
                    .foregroundColor(.blue)
                    
                    Button(role: .destructive) {
                        LogManager.shared.limparLogs()
                    } label: {
                        Label("Limpar Todos os Logs", systemImage: "trash")
                    }
                    
                    Button {
                        viewModel.simularErro()
                    } label: {
                        Label("Testar Tratamento de Erro", systemImage: "exclamationmark.triangle")
                    }
                    .foregroundColor(.orange)
                }
                
                // MARK: - Seção: Informações Técnicas
                Section("Informações Técnicas") {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Arquitetura: MVVM")
                            .font(.caption)
                        
                        Text("SwiftUI: Declarativo e Reativo")
                            .font(.caption)
                        
                        Text("@Published: Atualizações Automáticas")
                            .font(.caption)
                        
                        Text("Combine: Streams de Dados")
                            .font(.caption)
                        
                        Text("UserDefaults: Persistência Local")
                            .font(.caption)
                    }
                    .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Configurações")
        }
        .onAppear {
            print("🟢 ConfiguracoesView onAppear()")
            viewModel.viewApareceu(nomeView: "ConfiguracoesView")
        }
        .onDisappear {
            print("🔴 ConfiguracoesView onDisappear()")
            viewModel.viewDesapareceu(nomeView: "ConfiguracoesView")
        }
    }
    
    private func faseString(_ fase: ScenePhase) -> String {
        switch fase {
        case .active: return "Ativo"
        case .inactive: return "Inativo"
        case .background: return "Background"
        @unknown default: return "Desconhecido"
        }
    }
}

struct InfoRow: View {
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
