//
//  NotificacaoViewModel.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 20/01/26.
//


import Foundation
import UserNotifications
import Combine
import SwiftUI

/// ViewModel principal para gerenciar notificações
class NotificacaoViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var notificacoes: [Notificacao] = []
    @Published var notificacoesAtivas: [Notificacao] = []
    @Published var badgeCount: Int = 0
    @Published var estaAgendando: Bool = false
    @Published var mostrarAlerta: Bool = false
    @Published var alertaTitulo: String = ""
    @Published var alertaMensagem: String = ""
    @Published var ultimaNotificacao: Date? = nil
    @Published var estaRecebendoNotificacao: Bool = false
    
    // MARK: - Private Properties
    private let notificationCenter = UNUserNotificationCenter.current()
    private let badgeManager = BadgeManager.shared
    private let userDefaults = UserDefaults.standard
    private var cancellables = Set<AnyCancellable>()
    private var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    
    // Chaves para UserDefaults
    private let notificacoesKey = "notificacoes_salvas"
    private let badgeKey = "badge_count"
    private let configKey = "configuracao_notificacoes"
    
    // MARK: - Configuração
    var configuracoes: ConfiguracaoNotificacao {
        get {
            if let data = userDefaults.data(forKey: configKey),
               let config = try? JSONDecoder().decode(ConfiguracaoNotificacao.self, from: data) {
                return config
            }
            return ConfiguracaoNotificacao()
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                userDefaults.set(data, forKey: configKey)
            }
        }
    }
    
    // MARK: - Init
    init() {
        print("🔵 NotificacaoViewModel init() - Inicializando")
        carregarDados()
        observarNotificacoes()
        observarBadge()
        configurarObservadoresApp()
    }
    
    // MARK: - Public Methods
    
    /// Agenda uma nova notificação
    func agendarNotificacao(titulo: String, 
                           mensagem: String, 
                           data: Date,
                           repetir: Notificacao.RepeticaoNotificacao = .nunca,
                           categoria: Notificacao.CategoriaNotificacao = .lembrete,
                           badge: Int? = nil) {
        
        print("📅 Agendando notificação: \(titulo) para \(data)")
        estaAgendando = true
        
        // Criar ID único para a notificação
        let id = UUID().uuidString
        
        // Criar modelo
        let novaNotificacao = Notificacao(
            id: id,
            titulo: titulo,
            mensagem: mensagem,
            dataAgendamento: data,
            repetir: repetir,
            categoria: categoria,
            badge: badge,
            som: configuracoes.somPadrao
        )
        
        // Criar conteúdo da notificação
        let content = UNMutableNotificationContent()
        content.title = titulo
        content.body = mensagem
        content.sound = UNNotificationSound(named: UNNotificationSoundName(configuracoes.somPadrao + ".caf"))
        content.categoryIdentifier = "LEMBRETE_CATEGORY"
        
        // Configurar badge se habilitado
        if configuracoes.mostrarBadge, let badgeValue = badge {
            content.badge = badgeValue as NSNumber
        } else if configuracoes.mostrarBadge {
            // Incrementar badge automático
            badgeCount += 1
            content.badge = badgeCount as NSNumber
            salvarBadgeCount()
        }
        
        // Criar trigger baseado na repetição
        let trigger = criarTrigger(para: data, repeticao: repetir)
        
        // Criar request
        let request = UNNotificationRequest(
            identifier: id,
            content: content,
            trigger: trigger
        )
        
        // Agendar notificação
        notificationCenter.add(request) { [weak self] error in
            DispatchQueue.main.async {
                self?.estaAgendando = false
                
                if let error = error {
                    print("❌ Erro ao agendar notificação: \(error)")
                    self?.mostrarAlerta = true
                    self?.alertaTitulo = "Erro"
                    self?.alertaMensagem = "Não foi possível agendar: \(error.localizedDescription)"
                    return
                }
                
                print("✅ Notificação agendada com sucesso: \(id)")
                
                // Adicionar ao array local
                self?.notificacoes.append(novaNotificacao)
                self?.atualizarNotificacoesAtivas()
                self?.salvarNotificacoes()
                
                self?.mostrarAlerta = true
                self?.alertaTitulo = "Sucesso!"
                self?.alertaMensagem = "Notificação agendada para \(self?.formatarData(data) ?? "")"
            }
        }
    }
    
    /// Cancela uma notificação agendada
    func cancelarNotificacao(id: String) {
        print("❌ Cancelando notificação: \(id)")
        
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [id])
        
        // Remover do array local
        if let index = notificacoes.firstIndex(where: { $0.id == id }) {
            notificacoes.remove(at: index)
            salvarNotificacoes()
            atualizarNotificacoesAtivas()
        }
        
        mostrarAlerta = true
        alertaTitulo = "Cancelada"
        alertaMensagem = "Notificação cancelada com sucesso"
    }
    
    /// Cancela todas as notificações
    func cancelarTodasNotificacoes() {
        print("🗑️ Cancelando todas as notificações")
        
        notificationCenter.removeAllPendingNotificationRequests()
        notificationCenter.removeAllDeliveredNotifications()
        
        // Limpar array local
        notificacoes.removeAll()
        salvarNotificacoes()
        atualizarNotificacoesAtivas()
        
        // Resetar badge
        badgeCount = 0
        UIApplication.shared.applicationIconBadgeNumber = 0
        salvarBadgeCount()
        
        mostrarAlerta = true
        alertaTitulo = "Limpeza Completa"
        alertaMensagem = "Todas as notificações foram canceladas"
    }
    
    /// Envia uma notificação de teste imediata
    func enviarNotificacaoTeste() {
        print("🧪 Enviando notificação de teste")
        
        let content = UNMutableNotificationContent()
        content.title = "Teste de Notificação 🎯"
        content.body = "Esta é uma notificação de teste do app!"
        content.sound = .default
        
        if configuracoes.mostrarBadge {
            badgeCount += 1
            content.badge = badgeCount as NSNumber
            salvarBadgeCount()
        }
        
        // Trigger imediato (5 segundos)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
        
        notificationCenter.add(request) { error in
            if let error = error {
                print("❌ Erro no teste: \(error)")
            } else {
                print("✅ Teste agendado com sucesso")
            }
        }
    }
    
    /// Atualiza o badge count na bandeja do app
    func atualizarBadgeCount(_ count: Int) {
        badgeCount = max(0, count)
        UIApplication.shared.applicationIconBadgeNumber = badgeCount
        salvarBadgeCount()
        print("🔢 Badge atualizado: \(badgeCount)")
    }
    
    /// Limpa o badge (zera a bandeja)
    func limparBadge() {
        badgeCount = 0
        UIApplication.shared.applicationIconBadgeNumber = 0
        salvarBadgeCount()
        print("🔢 Badge limpo")
    }
    
    /// Formata data para exibição
    func formatarData(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy HH:mm"
        return formatter.string(from: date)
    }
    
    // MARK: - Private Methods
    
    private func criarTrigger(para data: Date, repeticao: Notificacao.RepeticaoNotificacao) -> UNNotificationTrigger? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: data)
        
        switch repeticao {
        case .nunca:
            return UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        case .diariamente:
            var dailyComponents = DateComponents()
            dailyComponents.hour = calendar.component(.hour, from: data)
            dailyComponents.minute = calendar.component(.minute, from: data)
            return UNCalendarNotificationTrigger(dateMatching: dailyComponents, repeats: true)
        case .semanalmente:
            var weeklyComponents = calendar.dateComponents([.hour, .minute, .weekday], from: data)
            return UNCalendarNotificationTrigger(dateMatching: weeklyComponents, repeats: true)
        case .mensalmente:
            var monthlyComponents = calendar.dateComponents([.hour, .minute, .day], from: data)
            return UNCalendarNotificationTrigger(dateMatching: monthlyComponents, repeats: true)
        case .customizado:
            // Para customizado, usamos intervalo de tempo (ex: a cada 1 hora)
            return UNTimeIntervalNotificationTrigger(timeInterval: 3600, repeats: true)
        }
    }
    
    private func carregarDados() {
        print("📂 Carregando dados salvos")
        
        // Carregar notificações
        if let data = userDefaults.data(forKey: notificacoesKey),
           let notifs = try? JSONDecoder().decode([Notificacao].self, from: data) {
            notificacoes = notifs
            print("📝 \(notificacoes.count) notificações carregadas")
        }
        
        // Carregar badge count
        badgeCount = userDefaults.integer(forKey: badgeKey)
        UIApplication.shared.applicationIconBadgeNumber = badgeCount
        print("🔢 Badge count carregado: \(badgeCount)")
        
        atualizarNotificacoesAtivas()
    }
    
    private func salvarNotificacoes() {
        do {
            let data = try JSONEncoder().encode(notificacoes)
            userDefaults.set(data, forKey: notificacoesKey)
            print("💾 Notificações salvas: \(notificacoes.count)")
        } catch {
            print("❌ Erro ao salvar notificações: \(error)")
        }
    }
    
    private func salvarBadgeCount() {
        userDefaults.set(badgeCount, forKey: badgeKey)
    }
    
    private func atualizarNotificacoesAtivas() {
        notificacoesAtivas = notificacoes.filter { $0.estaAtiva }
        print("📊 Notificações ativas: \(notificacoesAtivas.count)/\(notificacoes.count)")
    }
    
    private func observarNotificacoes() {
        // Observar notificações entregues
        notificationCenter.getDeliveredNotifications { [weak self] notifications in
            DispatchQueue.main.async {
                let deliveredCount = notifications.count
                print("📨 Notificações entregues: \(deliveredCount)")
                
                // Atualizar status das notificações locais
                self?.atualizarStatusEntregues(notifications)
            }
        }
    }
    
    private func atualizarStatusEntregues(_ delivered: [UNNotification]) {
        let deliveredIds = delivered.map { $0.request.identifier }
        
        for index in notificacoes.indices {
            if deliveredIds.contains(notificacoes[index].id) {
                notificacoes[index].foiEntregue = true
            }
        }
        
        salvarNotificacoes()
        atualizarNotificacoesAtivas()
    }
    
    private func observarBadge() {
        // Observar mudanças no badge count
        $badgeCount
            .removeDuplicates()
            .sink { [weak self] novoValor in
                guard let self = self else { return }
                print("🔢 Badge count mudou: \(novoValor)")
                
                // Atualizar bandeja do app
                if self.configuracoes.mostrarBadge {
                    UIApplication.shared.applicationIconBadgeNumber = novoValor
                }
            }
            .store(in: &cancellables)
    }
    
    private func configurarObservadoresApp() {
        // Observar quando app vai para background
        NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)
            .sink { [weak self] _ in
                print("📴 App entrou em background")
                self?.iniciarBackgroundTask()
            }
            .store(in: &cancellables)
        
        // Observar quando app volta ao foreground
        NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)
            .sink { [weak self] _ in
                print("📱 App voltou ao foreground")
                self?.finalizarBackgroundTask()
                self?.atualizarNotificacoesAtivas()
            }
            .store(in: &cancellables)
        
        // Observar notificações recebidas
        NotificationCenter.default.publisher(for: Notification.Name("NotificacaoRecebida"))
            .sink { [weak self] notification in
                print("🔔 Notificação recebida no app")
                self?.estaRecebendoNotificacao = true
                
                // Simular recebimento por 3 segundos
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self?.estaRecebendoNotificacao = false
                }
            }
            .store(in: &cancellables)
    }
    
    private func iniciarBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            print("⏰ Background task expirando")
            self?.finalizarBackgroundTask()
        }
        
        print("🔄 Background task iniciada: \(backgroundTask)")
    }
    
    private func finalizarBackgroundTask() {
        if backgroundTask != .invalid {
            UIApplication.shared.endBackgroundTask(backgroundTask)
            backgroundTask = .invalid
            print("🔄 Background task finalizada")
        }
    }
    
    // MARK: - Deinit
    deinit {
        print("🗑️ NotificacaoViewModel deinit() - Limpando recursos")
        cancellables.removeAll()
        finalizarBackgroundTask()
    }
}