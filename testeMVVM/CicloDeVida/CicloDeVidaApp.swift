//
//  CicloDeVidaApp.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 20/01/26.
//


import SwiftUI

struct CicloDeVidaApp: View {
    @StateObject private var viewModel = CicloDeVidaViewModel()
    @Environment(\.scenePhase) private var scenePhase
    
    // MARK: - Ciclo de Vida do App
    init() {
        print("🚀 App init() - Aplicativo inicializando")
        configurarAparência()
    }
    
    var body: some View {
        NavigationStack {
            CicloVidaView()
                .environmentObject(viewModel)
                // MARK: - scenePhase (Ciclo de Vida do App)
                .onChange(of: scenePhase) { faseAntiga, faseNova in
                    print("🌍 App: scenePhase mudou - \(faseAntiga) → \(faseNova)")
                    viewModel.atualizarFaseApp(faseNova)
                }
                // MARK: - NotificationCenter (Eventos do Sistema)
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                    print("📱 App: willResignActiveNotification")
                    viewModel.adicionarLog("App vai para background",
                                          descricao: "Usuário saiu do app",
                                          view: "Sistema",
                                          cor: .warning)
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                    print("📱 App: didBecomeActiveNotification")
                    viewModel.adicionarLog("App voltou ao foreground",
                                          descricao: "Usuário retornou ao app",
                                          view: "Sistema",
                                          cor: .success)
                }
        }
    }
    
    private func configurarAparência() {
        // Configurações globais de UI
        UITableView.appearance().backgroundColor = .clear
        
        // Personalização da Navigation Bar
        let aparicao = UINavigationBarAppearance()
        aparicao.configureWithOpaqueBackground()
        aparicao.backgroundColor = UIColor.systemBackground
        UINavigationBar.appearance().standardAppearance = aparicao
        UINavigationBar.appearance().scrollEdgeAppearance = aparicao
        
        print("🎨 Aparência configurada")
    }
}
