import Foundation
import UserNotifications
import Combine

/// Gerenciador especializado para badges
class BadgeManager: ObservableObject {
    static let shared = BadgeManager()
    
    @Published var currentBadge: Int = 0
    @Published var badgeHistory: [BadgeEvent] = []
    
    private let userDefaults = UserDefaults.standard
    private let badgeKey = "badge_manager_history"
    private let maxHistory = 50
    
    struct BadgeEvent: Identifiable, Codable {
        let id = UUID()
        let timestamp: Date
        let oldValue: Int
        let newValue: Int
        let reason: String
        
        var formattedTime: String {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm:ss"
            return formatter.string(from: timestamp)
        }
    }
    
    private init() {
        loadBadgeHistory()
        currentBadge = UIApplication.shared.applicationIconBadgeNumber
    }
    
    /// Atualiza o badge com uma nova contagem
    func updateBadge(_ count: Int, reason: String = "Manual") {
        let oldValue = currentBadge
        currentBadge = max(0, count) // Badge não pode ser negativo
        
        // Atualizar na bandeja do app
        UIApplication.shared.applicationIconBadgeNumber = currentBadge
        
        // Registrar evento
        let event = BadgeEvent(
            timestamp: Date(),
            oldValue: oldValue,
            newValue: currentBadge,
            reason: reason
        )
        
        badgeHistory.insert(event, at: 0)
        
        // Limitar histórico
        if badgeHistory.count > maxHistory {
            badgeHistory.removeLast()
        }
        
        saveBadgeHistory()
        
        print("🔢 BadgeManager: \(oldValue) → \(currentBadge) (\(reason))")
    }
    
    /// Incrementa o badge em 1
    func incrementBadge(reason: String = "Incremento") {
        updateBadge(currentBadge + 1, reason: reason)
    }
    
    /// Decrementa o badge em 1
    func decrementBadge(reason: String = "Decremento") {
        updateBadge(currentBadge - 1, reason: reason)
    }
    
    /// Reseta o badge para 0
    func resetBadge(reason: String = "Reset") {
        updateBadge(0, reason: reason)
    }
    
    /// Configura badge baseado em notificações pendentes
    func syncWithPendingNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            let badgeCount = requests.count
            DispatchQueue.main.async {
                self.updateBadge(badgeCount, reason: "Sincronização com notificações pendentes")
            }
        }
    }
    
    private func saveBadgeHistory() {
        do {
            let data = try JSONEncoder().encode(badgeHistory)
            userDefaults.set(data, forKey: badgeKey)
        } catch {
            print("❌ Erro ao salvar histórico de badges: \(error)")
        }
    }
    
    private func loadBadgeHistory() {
        guard let data = userDefaults.data(forKey: badgeKey) else { return }
        
        do {
            badgeHistory = try JSONDecoder().decode([BadgeEvent].self, from: data)
        } catch {
            print("❌ Erro ao carregar histórico de badges: \(error)")
        }
    }
    
    func clearHistory() {
        badgeHistory.removeAll()
        saveBadgeHistory()
        print("🗑️ BadgeManager: Histórico limpo")
    }
}