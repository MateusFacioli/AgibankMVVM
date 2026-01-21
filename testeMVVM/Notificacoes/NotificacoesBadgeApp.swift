//
//  NotificacoesBadgeApp.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 20/01/26.
//


import SwiftUI
import UserNotifications

struct NotificacoesBadgeApp: View {
    @StateObject private var permissaoVM = PermissaoViewModel()
    @StateObject private var notificacaoVM = NotificacaoViewModel()
    @Environment(\.scenePhase) private var scenePhase
    
    // MARK: - Init do App
    init() {
        print("🚀 NotificacoesBadgeApp init() - App inicializando")
        configurarAparencia()
        configurarNotificacoesIniciais()
    }
    
    var body: some View {
        NavigationStack {
            NotificationView()
                .environmentObject(permissaoVM)
                .environmentObject(notificacaoVM)
                // MARK: - Observar ciclo de vida do app
                .onChange(of: scenePhase) { faseAntiga, faseNova in
                    print("🌍 App: scenePhase mudou - \(faseAntiga) → \(faseNova)")
                    
                    switch faseNova {
                    case .active:
                        print("📱 App está ativo")
                        // Atualizar badge quando app volta ao foreground
                        notificacaoVM.atualizarBadgeCount(notificacaoVM.badgeCount)
                        
                    case .inactive:
                        print("⏸️ App está inativo")
                        
                    case .background:
                        print("📴 App está em background")
                        // Salvar dados antes de ir para background
                        notificacaoVM.salvarNotificacoes()
                        
                    @unknown default:
                        break
                    }
                }
                // MARK: - Observar notificações do sistema
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                    print("🔔 App voltou ao foreground")
                    // Atualizar estado quando usuário volta ao app
                    permissaoVM.verificarPermissaoInicial()
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                    print("🔔 App vai para background")
                }
        }
    }
    
    // MARK: - Configurações Iniciais
    private func configurarAparencia() {
        // Configurar navigation bar
        let aparicao = UINavigationBarAppearance()
        aparicao.configureWithOpaqueBackground()
        aparicao.backgroundColor = UIColor.systemBackground
        
        UINavigationBar.appearance().standardAppearance = aparicao
        UINavigationBar.appearance().scrollEdgeAppearance = aparicao
        
        print("🎨 Aparência configurada")
    }
    
    private func configurarNotificacoesIniciais() {
        // Configurar delegate do notification center
        UNUserNotificationCenter.current().delegate = NotificationServiceDelegate.shared
        
        print("🔔 Notification Center configurado")
    }
}
