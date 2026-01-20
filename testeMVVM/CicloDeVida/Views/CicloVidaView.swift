//
//  CicloVidaView.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 20/01/26.
//


//
//  CicloVidaView.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 20/01/26.
//


import SwiftUI

struct CicloVidaView: View {
    @StateObject private var viewModel = CicloDeVidaViewModel()
    @State private var selecionarAba = 0
    @State private var mostrarDetalhes = false
    @State private var viewInicializada = false
    
    // MARK: - Init (Equivalente a viewDidLoad)
    init() {
        print("🔵 ContentView init() - Struct inicializada")
        // Em SwiftUI, init() é chamado quando a struct é criada
        // Não é bom lugar para lógica pesada, só configurações iniciais
    }
    
    var body: some View {
        TabView(selection: $selecionarAba) {
            // MARK: - Tab 1: Tela Principal
            TelaPrincipalView(viewModel: viewModel)
                .tabItem {
                    Label("Ciclo", systemImage: "arrow.clockwise.circle.fill")
                }
                .tag(0)
            
            // MARK: - Tab 2: Etapas Detalhadas
            DetalhesCicloView(viewModel: viewModel)
                .tabItem {
                    Label("Etapas", systemImage: "list.bullet")
                }
                .tag(1)
            
            // MARK: - Tab 3: Logs
            LogsView(viewModel: viewModel)
                .tabItem {
                    Label("Logs", systemImage: "terminal.fill")
                }
                .tag(2)
            
            // MARK: - Tab 4: Configurações
            ConfiguracoesView(viewModel: viewModel)
                .tabItem {
                    Label("Info", systemImage: "info.circle.fill")
                }
                .tag(3)
        }
        .accentColor(.blue)
        // MARK: - onAppear (Equivalente a viewDidAppear) - apenas 1 vez quando a tela antes de aparecer irá chamar
        .onAppear {
            print("🟢 ContentView onAppear() - View apareceu na tela")
            viewModel.viewApareceu(nomeView: "ContentView")
            
            // Marcar que a view foi inicializada
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                viewInicializada = true
            }
        }
        // MARK: - onDisappear (Equivalente a viewDidDisappear)
        .onDisappear {
            print("🔴 ContentView onDisappear() - View desapareceu")
            viewModel.viewDesapareceu(nomeView: "ContentView")
        }
        // MARK: - onChange (Observa mudanças)
        .onChange(of: selecionarAba) { valorAntigo, valorNovo in
            print("🟡 ContentView onChange() - Aba mudou: \(valorAntigo) → \(valorNovo)")
            viewModel.propriedadeMudou(nome: "selecionarAba", 
                                      valorAntigo: valorAntigo, 
                                      valorNovo: valorNovo)
        }
        // MARK: - task (Tarefas assíncronas)
        .task {
            print("🌀 ContentView task() - Tarefa assíncrona iniciada")
            // Aqui poderia carregar dados da API
            try? await Task.sleep(nanoseconds: 500_000_000) // 0.5s
            print("🌀 ContentView task() - Tarefa assíncrona concluída")
        }
    }
}

// MARK: - Deinit não existe em structs SwiftUI, mas podemos usar um wrapper
// SwiftUI Views são structs, então não têm deinit. Use o deinit do ViewModel.
