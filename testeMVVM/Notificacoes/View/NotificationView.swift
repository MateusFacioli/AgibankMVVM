//
//  NotificationView.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 20/01/26.
//


import SwiftUI

struct NotificationView: View {
    @StateObject private var permissaoVM = PermissaoViewModel()
    @StateObject private var notificacaoVM = NotificacaoViewModel()
    @State private var selecionarAba = 0
    
    // MARK: - Init (Ciclo de Vida)
    init() {
        print("🔵 ContentView init() - Struct inicializada")
        // Em SwiftUI, init() é chamado quando a struct é criada
        // Configurações iniciais podem ser feitas aqui
    }
    
    var body: some View {
        TabView(selection: $selecionarAba) {
            // MARK: - Tab 1: Painel Principal
            PainelNotificacoesView(
                permissaoVM: permissaoVM,
                notificacaoVM: notificacaoVM
            )
            .tabItem {
                Label("Notificações", systemImage: "bell.fill")
            }
            .badge(notificacaoVM.badgeCount)
            .tag(0)
            
            // MARK: - Tab 2: Criar Notificação
            CriarNotificacaoView(notificacaoVM: notificacaoVM)
                .tabItem {
                    Label("Criar", systemImage: "plus.circle.fill")
                }
                .tag(1)
            
            // MARK: - Tab 3: Histórico
            HistoricoView(notificacaoVM: notificacaoVM)
                .tabItem {
                    Label("Histórico", systemImage: "clock.fill")
                }
                .tag(2)
            
            // MARK: - Tab 4: Configurações
            ConfiguracoesNotificationView(
                permissaoVM: permissaoVM,
                notificacaoVM: notificacaoVM
            )
            .tabItem {
                Label("Config", systemImage: "gearshape.fill")
            }
            .tag(3)
        }
        .accentColor(.blue)
        // MARK: - onAppear (Ciclo de Vida - View aparece)
        .onAppear {
            print("🟢 ContentView onAppear() - View apareceu na tela")
            
            // Solicitar permissão automaticamente se necessário
            if permissaoVM.statusPermissao == .notDetermined {
                print("🔔 Solicitando permissão automaticamente...")
                // Pequeno delay para melhor experiência do usuário
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    permissaoVM.solicitarPermissao()
                }
            }
        }
        // MARK: - onDisappear (Ciclo de Vida - View desaparece)
        .onDisappear {
            print("🔴 ContentView onDisappear() - View desapareceu")
        }
        // MARK: - onChange (Observa mudanças na aba selecionada)
        .onChange(of: selecionarAba) { valorAntigo, valorNovo in
            print("🟡 ContentView onChange() - Aba mudou: \(valorAntigo) → \(valorNovo)")
        }
        // MARK: - task (Tarefas assíncronas)
        .task {
            print("🌀 ContentView task() - Tarefas assíncronas iniciadas")
            // Aqui poderíamos carregar dados da API, etc.
        }
        // MARK: - Alertas do sistema
        .alert(permissaoVM.alertaMensagem, isPresented: $permissaoVM.mostrarAlerta) {
            Button("OK") { }
        }
        .alert(notificacaoVM.alertaTitulo, isPresented: $notificacaoVM.mostrarAlerta) {
            Button("OK") { }
        } message: {
            Text(notificacaoVM.alertaMensagem)
        }
    }
}
