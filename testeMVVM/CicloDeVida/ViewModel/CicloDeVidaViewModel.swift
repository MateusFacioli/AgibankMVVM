//
//  CicloDeVidaViewModel.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 20/01/26.
//


import Foundation
import SwiftUI
import Combine

class CicloDeVidaViewModel: ObservableObject {
    // MARK: - Published Properties (Estado da UI)
    @Published var contadorAparicoes: Int = 0
    @Published var contadorDesaparicoes: Int = 0
    @Published var tempoVisivel: TimeInterval = 0
    @Published var ultimaAtualizacao: Date = Date()
    @Published var estaVisivel: Bool = false
    @Published var faseApp: ScenePhase = .active
    @Published var logs: [Log] = []
    @Published var timerAtivo: Bool = false
    
    // MARK: - Private Properties
    private var timer: Timer?
    private var inicioVisibilidade: Date?
    private let logManager = LogManager.shared // singleton
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init (Equivalente a viewDidLoad)
    init() {
        print("🔵 ViewModel init() - Inicialização do ViewModel")
        adicionarLog("ViewModel init()", descricao: "ViewModel inicializado", cor: .info)
        
        // Configurar observadores
        configurarObservadores()
    }
    
    // MARK: - Ciclo de Vida Methods
    
    /// Chamado quando a View aparece (onAppear)
    func viewApareceu(nomeView: String) {
        print("🟢 ViewModel: viewApareceu - \(nomeView)")
        
        estaVisivel = true
        contadorAparicoes += 1
        inicioVisibilidade = Date()
        ultimaAtualizacao = Date()
        
        adicionarLog("View Apareceu", 
                    descricao: "\(nomeView) apareceu na tela",
                    view: nomeView,
                    cor: .success)
        
        iniciarTimer()
    }
    
    /// Chamado quando a View desaparece (onDisappear)
    func viewDesapareceu(nomeView: String) {
        print("🔴 ViewModel: viewDesapareceu - \(nomeView)")
        
        estaVisivel = false
        contadorDesaparicoes += 1
        
        if let inicio = inicioVisibilidade {
            let tempo = Date().timeIntervalSince(inicio)
            tempoVisivel += tempo
            inicioVisibilidade = nil
        }
        
        adicionarLog("View Desapareceu",
                    descricao: "\(nomeView) desapareceu da tela",
                    view: nomeView,
                    cor: .warning)
        
        pararTimer()
    }
    
    /// Chamado quando uma propriedade @Published muda (onChange)
    func propriedadeMudou<T: Equatable>(nome: String, valorAntigo: T, valorNovo: T) {
        print("🟡 ViewModel: propriedadeMudou - \(nome): \(valorAntigo) → \(valorNovo)")
        
        adicionarLog("Propriedade Alterada",
                    descricao: "\(nome) mudou de \(valorAntigo) para \(valorNovo)",
                    view: "ViewModel",
                    cor: .info)
    }
    
    /// Atualiza fase do app (scenePhase)
    func atualizarFaseApp(_ fase: ScenePhase) {
        guard self.faseApp != fase else { return }
        
        let faseAntiga = self.faseApp
        self.faseApp = fase
        
        print("🟣 ViewModel: Fase App mudou - \(faseAntiga) → \(fase)")
        
        adicionarLog("Fase App Alterada",
                     descricao: "App mudou de \(faseAntiga) para \(fase)",
                    view: "App",
                    cor: .info)
        
        // Lógica baseada na fase do app
        switch fase {
        case .active:
            print("📱 App está ativo")
            if estaVisivel {
                iniciarTimer()
            }
        case .inactive:
            print("⏸️ App está inativo")
        case .background:
            print("📴 App está em background")
            pararTimer()
        @unknown default:
            break
        }
    }
    
    // MARK: - Timer Methods
    
    private func iniciarTimer() {
        guard !timerAtivo else { return }
        
        timerAtivo = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self, self.estaVisivel else { return }
            
            self.tempoVisivel += 1
            self.ultimaAtualizacao = Date()
            
            // Log a cada 5 segundos
            if Int(self.tempoVisivel) % 5 == 0 {
                self.adicionarLog("Timer Ativo",
                                descricao: "View visível por \(Int(self.tempoVisivel)) segundos",
                                view: "Sistema",
                                cor: .info)
            }
        }
        
        print("⏱️ Timer iniciado")
    }
    
    private func pararTimer() {
        timer?.invalidate()
        timer = nil
        timerAtivo = false
        print("⏱️ Timer parado")
    }
    
    // MARK: - Log Methods
    
     func adicionarLog(_ evento: String, descricao: String, view: String = "ViewModel", cor: Log.LogCor = .info) {
        let log = Log(
            timestamp: Date(),
            evento: evento,
            descricao: descricao,
            view: view,
            cor: cor,
            icone: obterIconeParaEvento(evento)
        )
        
        DispatchQueue.main.async {
            self.logs.insert(log, at: 0)
            self.logManager.adicionarLog(log)
            
            // Manter apenas últimos 50 logs
            if self.logs.count > 50 {
                self.logs.removeLast()
            }
        }
    }
    
    private func obterIconeParaEvento(_ evento: String) -> String {
        switch evento {
        case let str where str.contains("Apareceu"): return "eye.fill"
        case let str where str.contains("Desapareceu"): return "eye.slash.fill"
        case let str where str.contains("Alterada"): return "arrow.left.arrow.right"
        case let str where str.contains("Timer"): return "timer"
        case let str where str.contains("init"): return "bolt.fill"
        default: return "info.circle.fill"
        }
    }
    
    // MARK: - Configuração
    
    private func configurarObservadores() {
        // Observar mudanças no contador de aparições
        $contadorAparicoes
            .sink { [weak self] novoValor in
                guard let self = self else { return }
                print("🔢 Contador aparições atualizado: \(novoValor)")
            }
            .store(in: &cancellables)
        
        // Observar mudanças na visibilidade
        $estaVisivel
            .removeDuplicates()
            .sink { [weak self] visivel in
                guard let self = self else { return }
                print(visivel ? "👁️ View ficou visível" : "🙈 View ficou invisível")
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Deinit - está crashando no app ao voltar do ciclo de vida
//    deinit {
//        print("🗑️ ViewModel deinit() - ViewModel sendo destruído")
//        pararTimer()
//        cancellables.removeAll()
//        
//        adicionarLog("ViewModel deinit",
//                    descricao: "ViewModel destruído da memória",
//                    cor: .error)
//    }
    
    // MARK: - Public Methods
    
    func simularErro() {
        print("❌ Simulando erro no ViewModel")
        adicionarLog("Erro Simulado",
                    descricao: "Erro intencional para demonstrar tratamento",
                    cor: .error)
    }
    
    func resetarContadores() {
        contadorAparicoes = 0
        contadorDesaparicoes = 0
        tempoVisivel = 0
        logs.removeAll()
        
        adicionarLog("Contadores Resetados",
                    descricao: "Todos os contadores foram zerados",
                    cor: .info)
    }
    
    func exportarLogs() -> String {
        var export = "LOGS DO CICLO DE VIDA - \(Date())\n"
        export += "================================\n\n"
        
        for log in logs.reversed() {
            export += "[\(log.timestampFormatado)] \(log.evento): \(log.descricao)\n"
        }
        
        return export
    }
}
