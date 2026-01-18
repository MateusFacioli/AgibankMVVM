//
//  CalendarioViewModel.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 18/01/26.
//


import Foundation
import Combine
internal import EventKit
import UIKit

class CalendarioViewModel: ObservableObject {
    @Published var statusPermissao: EKAuthorizationStatus = .notDetermined
    @Published var mensagem: String = "Verificando permissões..."
    @Published var estaSolicitando: Bool = false
    
    private let eventStore = EKEventStore()
    private let userDefaults = UserDefaults.standard
    private let jaSolicitouKey = "permissaoCalendarioJaSolicitada"
    
    init() {
        // Verifica status imediatamente
        verificarStatusInicial()
        
        // Solicita automaticamente se necessário
        solicitarPermissaoSeNecessario()
    }
    
    private func verificarStatusInicial() {
        DispatchQueue.main.async {
            self.statusPermissao = EKEventStore.authorizationStatus(for: .event)
            self.atualizarMensagem()
        }
    }
    
    private func solicitarPermissaoSeNecessario() {
        print("🔍 Verificando se deve solicitar..." )
        print("🔍 Status: \(statusPermissao.rawValue)")
        print("🔍 Já solicitou: \(userDefaults.bool(forKey: jaSolicitouKey))")
        // Verifica se já foi solicitado antes
        let jaSolicitou = userDefaults.bool(forKey: jaSolicitouKey)
        
        // Aguarda um momento para a UI carregar
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // Só solicita se:
            // 1. Status for "não determinado" (primeira vez)
            // 2. Ainda não tiver sido solicitado
            // 3. App estiver em primeiro plano
            
            guard self.statusPermissao == .notDetermined,
                  !jaSolicitou,
                  UIApplication.shared.applicationState == .active else {
                return
            }
            
            self.estaSolicitando = true
            self.mensagem = "Solicitando acesso ao calendário..."
            
            // Faz a solicitação AUTOMÁTICA
            self.fazerSolicitacaoNativa()
        }
    }
    
    private func fazerSolicitacaoNativa() {
        if #available(iOS 17.0, *) {
            // iOS 17+ - Novo método
            eventStore.requestFullAccessToEvents { [weak self] concedido, error in
                DispatchQueue.main.async {
                    self?.processarResposta(concedido: concedido, error: error)
                }
            }
        } else {
            // iOS 16 e anteriores
            eventStore.requestAccess(to: .event) { [weak self] concedido, error in
                DispatchQueue.main.async {
                    self?.processarResposta(concedido: concedido, error: error)
                }
            }
        }
    }
    
    private func processarResposta(concedido: Bool, error: Error?) {
        self.estaSolicitando = false
        
        // Marca que já foi solicitado (independente da resposta)
        self.userDefaults.set(true, forKey: self.jaSolicitouKey)
        
        // Atualiza status
        self.statusPermissao = EKEventStore.authorizationStatus(for: .event)
        self.atualizarMensagem()
        
        // Log para debug
        if let error = error {
            print("Erro na solicitação: \(error.localizedDescription)")
        } else {
            print("Permissão \(concedido ? "concedida" : "negada")")
        }
    }
    
    private func atualizarMensagem() {
        switch statusPermissao {
        case .notDetermined:
            mensagem = "Aguardando solicitação de permissão..."
        case .restricted:
            mensagem = "Acesso ao calendário está restrito pelas configurações do dispositivo."
        case .denied:
            mensagem = "Permissão para acessar o calendário foi negada. Você pode alterar nas Configurações."
        case .authorized:
            mensagem = "Acesso ao calendário permitido! Você pode criar eventos."
        case .fullAccess:
            mensagem = "Acesso completo ao calendário permitido!"
        @unknown default:
            mensagem = "Status de permissão desconhecido."
        }
    }
    
    // Método para o usuário solicitar manualmente (caso tenha negado antes)
    func solicitarPermissaoManual() {
        estaSolicitando = true
        mensagem = "Solicitando acesso..."
        fazerSolicitacaoNativa()
    }
    
    // Método para criar evento
    func criarEvento(_ evento: Evento) -> Result<Void, Error> {
        guard podeCriarEventos else {
            return .failure(NSError(domain: "Sem permissão", code: 403))
        }
        
        let ekEvent = evento.toEKEvent(store: eventStore)
        
        do {
            try eventStore.save(ekEvent, span: .thisEvent)
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    var podeCriarEventos: Bool {
        return statusPermissao == .authorized || statusPermissao == .fullAccess
    }
}
