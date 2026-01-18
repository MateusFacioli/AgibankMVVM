//
//  PermissoesView.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 18/01/26.
//


import SwiftUI
internal import EventKit

struct PermissoesView: View {
    @StateObject private var viewModel = CalendarioViewModel()
    @State private var mostrarCriarEvento = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                // Header com ícone
                VStack(spacing: 15) {
                    Image(systemName: iconStatus)
                        .font(.system(size: 70))
                        .foregroundColor(corStatus)
                        .symbolEffect(.pulse, isActive: viewModel.estaSolicitando)
                    
                    Text(tituloStatus)
                        .font(.title2)
                        .fontWeight(.semibold)
                }
                .padding(.top, 50)
                
                // Mensagem de status
                Text(viewModel.mensagem)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                // Botão de ação principal (só aparece se necessário)
                if !viewModel.podeCriarEventos && !viewModel.estaSolicitando {
                    VStack(spacing: 20) {
                        if viewModel.statusPermissao == .denied {
                            Button("Abrir Configurações para Permitir") {
                                abrirConfiguracoes()
                            }
                            .buttonStyle(.borderedProminent)
                        } else if viewModel.statusPermissao == .notDetermined {
                            Button("Solicitar Permissão Agora") {
                                viewModel.solicitarPermissaoManual()
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        
                        Button("Pular por enquanto") {
                            // Continua sem permissão
                        }
                        .font(.caption)
                        .foregroundColor(.secondary)
                    }
                }
                
                // Botão para criar evento (só aparece se tiver permissão)
                if viewModel.podeCriarEventos {
                    VStack(spacing: 20) {
                        Button {
                            mostrarCriarEvento = true
                        } label: {
                            Label("Criar Primeiro Evento", systemImage: "calendar.badge.plus")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(.horizontal)
                        
                        Text("Permissão concedida! Você já pode usar todas as funcionalidades.")
                            .font(.caption)
                            .foregroundColor(.green)
                    }
                }
                
                Spacer()
                
                // Indicador de atividade
                if viewModel.estaSolicitando {
                    ProgressView()
                        .scaleEffect(1.2)
                    Text("Aguardando sua resposta...")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                // Footer informativo
                VStack(alignment: .leading, spacing: 8) {
                    Text("Como funciona:")
                        .font(.caption)
                        .fontWeight(.medium)
                    
                    Text("• Na primeira abertura, pedimos acesso automaticamente")
                        .font(.caption2)
                    
                    Text("• Você pode permitir ou negar no diálogo do sistema")
                        .font(.caption2)
                    
                    Text("• Sem acesso, funcionalidades ficam limitadas")
                        .font(.caption2)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .navigationTitle("Calendário App")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $mostrarCriarEvento) {
                CriarEventoView(viewModel: viewModel)
            }
        }
    }
    
    private var iconStatus: String {
        if viewModel.estaSolicitando {
            return "clock"
        }
        
        switch viewModel.statusPermissao {
        case .notDetermined: return "questionmark.circle"
        case .denied, .restricted: return "xmark.circle"
        case .authorized, .fullAccess: return "checkmark.circle"
        @unknown default: return "exclamationmark.circle"
        }
    }
    
    private var corStatus: Color {
        if viewModel.estaSolicitando {
            return .orange
        }
        
        switch viewModel.statusPermissao {
        case .notDetermined: return .gray
        case .denied, .restricted: return .red
        case .authorized, .fullAccess: return .green
        @unknown default: return .orange
        }
    }
    
    private var tituloStatus: String {
        if viewModel.estaSolicitando {
            return "Solicitando Permissão"
        }
        
        switch viewModel.statusPermissao {
        case .notDetermined: return "Permissão Necessária"
        case .denied: return "Acesso Negado"
        case .restricted: return "Acesso Restrito"
        case .authorized: return "Acesso Permitido"
        case .fullAccess: return "Acesso Completo"
        @unknown default: return "Status Desconhecido"
        }
    }
    
    private func abrirConfiguracoes() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }
}
