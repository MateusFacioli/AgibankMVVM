//
//  PermissaoViewModel.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 20/01/26.
//


import Foundation
import UserNotifications
import Combine
import UIKit

/// ViewModel para gerenciar permissões de notificação
class PermissaoViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var statusPermissao: UNAuthorizationStatus = .notDetermined
    @Published var estaSolicitando: Bool = false
    @Published var mensagemStatus: String = "Verificando permissões..."
    @Published var mostrarAlerta: Bool = false
    @Published var alertaMensagem: String = ""
    
    // MARK: - Private Properties
    private let notificationCenter = UNUserNotificationCenter.current()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init() {
        print("🔵 PermissaoViewModel init() - Inicializando")
        verificarPermissaoInicial()
        observarMudancasPermissao()
    }
    
    // MARK: - Public Methods
    
    /// Verifica a permissão atual (equivalente a viewDidLoad)
    func verificarPermissaoInicial() {
        print("🔍 Verificando permissão inicial de notificações")
        
        notificationCenter.getNotificationSettings { [weak self] settings in
            DispatchQueue.main.async {
                self?.statusPermissao = settings.authorizationStatus
                self?.atualizarMensagemStatus()
                print("📊 Status de permissão: \(settings.authorizationStatus.rawValue)")
            }
        }
    }
    
    /// Solicita permissão para notificações
    func solicitarPermissao() {
        print("🟡 Solicitando permissão para notificações")
        estaSolicitando = true
        mensagemStatus = "Solicitando permissão..."
        
        // Opções de notificação que queremos solicitar
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        notificationCenter.requestAuthorization(options: options) { [weak self] granted, error in
            DispatchQueue.main.async {
                self?.estaSolicitando = false
                
                if let error = error {
                    print("❌ Erro ao solicitar permissão: \(error.localizedDescription)")
                    self?.mostrarAlerta = true
                    self?.alertaMensagem = "Erro: \(error.localizedDescription)"
                    return
                }
                
                if granted {
                    print("✅ Permissão concedida para notificações")
//                    self?.configurarCategoriasNotificacao()
                    self?.mostrarAlerta = true
                    self?.alertaMensagem = "Permissão concedida! Agora você pode receber notificações."
                } else {
                    print("❌ Permissão negada para notificações")
                    self?.mostrarAlerta = true
                    self?.alertaMensagem = "Permissão negada. Você pode alterar nas Configurações."
                }
                
                // Atualizar status após solicitação
                self?.verificarPermissaoInicial()
            }
        }
    }
    
    /// Abre configurações do sistema para usuário alterar permissões
    func abrirConfiguracoes() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
            print("⚙️ Abrindo configurações do sistema")
        }
    }
    
    // MARK: - Private Methods
    
    private func atualizarMensagemStatus() {
        switch statusPermissao {
        case .notDetermined:
            mensagemStatus = "Permissão ainda não foi solicitada"
        case .denied:
            mensagemStatus = "Permissão negada. Vá em Configurações para alterar."
        case .authorized:
            mensagemStatus = "Permissão concedida ✓"
        case .provisional:
            mensagemStatus = "Permissão provisória concedida"
        case .ephemeral:
            mensagemStatus = "Permissão temporária para app clips"
        @unknown default:
            mensagemStatus = "Status desconhecido"
        }
    }
    
    private func observarMudancasPermissao() {
        // Observar mudanças nas configurações de notificação
        NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)
            .sink { [weak self] _ in
                print("📱 App ficou ativo, verificando permissões...")
                self?.verificarPermissaoInicial()
            }
            .store(in: &cancellables)
    }
    
    private func configurarCategorasNotificacao() {
        print("🔧 Configurando categorias de notificação personalizadas")
        
        // Categoria para ações customizadas
        let lembreteAction = UNNotificationAction(
            identifier: "LEMBRAR_MAIS_TARDE",
            title: "Lembrar mais tarde",
            options: []
        )
        
        let completarAction = UNNotificationAction(
            identifier: "COMPLETAR",
            title: "Completar",
            options: [.foreground]
        )
        
        // Criar categoria com ações
        let lembreteCategory = UNNotificationCategory(
            identifier: "LEMBRETE_CATEGORY",
            actions: [lembreteAction, completarAction],
            intentIdentifiers: [],
            options: []
        )
        
        // Registrar categorias
        notificationCenter.setNotificationCategories([lembreteCategory])
        print("✅ Categorias de notificação configuradas")
    }
    
    // MARK: - Deinit
    deinit {
        print("🗑️ PermissaoViewModel deinit() - Limpando recursos")
        cancellables.removeAll()
    }
}
