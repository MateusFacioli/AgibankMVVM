//
//  NotificacaoService.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 20/01/26.
//


import Foundation
import UserNotifications
import Combine

/// Serviço para operações avançadas com notificações
class NotificacaoService {
    static let shared = NotificacaoService()
    
    private let notificationCenter = UNUserNotificationCenter.current()
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        print("🔧 NotificacaoService inicializado")
        setupNotificationDelegates()
    }
    
    /// Configura delegates para notificações
    private func setupNotificationDelegates() {
        notificationCenter.delegate = NotificationServiceDelegate.shared
        
        // Observar respostas a notificações
        NotificationCenter.default.publisher(for: Notification.Name("NotificacaoRespondida"))
            .sink { notification in
                if let response = notification.userInfo?["response"] as? UNNotificationResponse {
                    self.handleNotificationResponse(response)
                }
            }
            .store(in: &cancellables)
    }
    
    /// Trata respostas a notificações (quando usuário interage)
    private func handleNotificationResponse(_ response: UNNotificationResponse) {
        let notificationId = response.notification.request.identifier
        let actionId = response.actionIdentifier
        
        print("🔄 Resposta à notificação: \(notificationId)")
        print("   Ação: \(actionId)")
        
        switch actionId {
        case "LEMBRAR_MAIS_TARDE":
            print("   ↪️ Usuário pediu para lembrar mais tarde")
            rescheduleNotification(notificationId, minutesLater: 30)
            
        case "COMPLETAR":
            print("   ✅ Usuário marcou como completa")
            markNotificationAsCompleted(notificationId)
            
        case UNNotificationDefaultActionIdentifier:
            print("   👆 Usuário tocou na notificação")
            NotificationCenter.default.post(
                name: Notification.Name("NotificacaoTocada"),
                object: nil,
                userInfo: ["id": notificationId]
            )
            
        case UNNotificationDismissActionIdentifier:
            print("   ❌ Usuário dispensou a notificação")
            
        default:
            print("   🔧 Ação customizada: \(actionId)")
        }
    }
    
    /// Reagenda uma notificação para mais tarde
    private func rescheduleNotification(_ id: String, minutesLater: Int) {
        print("⏰ Reagendando notificação \(id) para \(minutesLater) minutos depois")
        
        notificationCenter.getPendingNotificationRequests { requests in
            if let request = requests.first(where: { $0.identifier == id }),
               let trigger = request.trigger as? UNCalendarNotificationTrigger {
                
                // Criar nova data (minutos depois)
                let newDate = Calendar.current.date(
                    byAdding: .minute,
                    value: minutesLater,
                    to: Date()
                ) ?? Date()
                
                // Criar novo trigger
                let components = Calendar.current.dateComponents(
                    [.year, .month, .day, .hour, .minute],
                    from: newDate
                )
                
                let newTrigger = UNCalendarNotificationTrigger(
                    dateMatching: components,
                    repeats: false
                )
                
                // Criar novo request
                let newRequest = UNNotificationRequest(
                    identifier: id + "_rescheduled",
                    content: request.content,
                    trigger: newTrigger
                )
                
                // Agendar
                self.notificationCenter.add(newRequest) { error in
                    if let error = error {
                        print("❌ Erro ao reagendar: \(error)")
                    } else {
                        print("✅ Notificação reagendada")
                    }
                }
            }
        }
    }
    
    /// Marca notificação como completa
    private func markNotificationAsCompleted(_ id: String) {
        print("✅ Marcando notificação \(id) como completa")
        // Aqui você pode atualizar seu modelo de dados local
        // ou fazer outras operações necessárias
    }
    
    /// Verifica permissões detalhadas
    func checkDetailedPermissions() -> Future<UNNotificationSettings, Error> {
        return Future { promise in
            self.notificationCenter.getNotificationSettings { settings in
                promise(.success(settings))
            }
        }
    }
    
    /// Obtém notificações agendadas
    func getScheduledNotifications() -> Future<[UNNotificationRequest], Error> {
        return Future { promise in
            self.notificationCenter.getPendingNotificationRequests { requests in
                promise(.success(requests))
            }
        }
    }
    
    /// Obtém notificações entregues
    func getDeliveredNotifications() -> Future<[UNNotification], Error> {
        return Future { promise in
            self.notificationCenter.getDeliveredNotifications { notifications in
                promise(.success(notifications))
            }
        }
    }
    
    deinit {
        print("🗑️ NotificacaoService deinit")
        cancellables.removeAll()
    }
}

/// Delegate para notificações
class NotificationServiceDelegate: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationServiceDelegate()
    
    private override init() {
        super.init()
        print("🔧 NotificationServiceDelegate inicializado")
    }
    
    // Chamado quando notificação é recebida com app em foreground
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        print("🔔 Notificação recebida em foreground: \(notification.request.identifier)")
        
        // Postar notificação para o ViewModel
        NotificationCenter.default.post(
            name: Notification.Name("NotificacaoRecebida"),
            object: nil,
            userInfo: ["notification": notification]
        )
        
        // Decidir como mostrar a notificação
        // No iOS 14+, podemos escolher mostrar banner, som e badge
        let options: UNNotificationPresentationOptions = [.banner, .sound, .badge]
        completionHandler(options)
    }
    
    // Chamado quando usuário interage com notificação
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        print("👆 Usuário interagiu com notificação")
        
        // Postar resposta para o serviço tratar
        NotificationCenter.default.post(
            name: Notification.Name("NotificacaoRespondida"),
            object: nil,
            userInfo: ["response": response]
        )
        
        completionHandler()
    }
}