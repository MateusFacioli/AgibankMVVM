//
//  ConfiguracaoNotificacao.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 21/01/26.
//


/// Modelo para configurações de notificação
struct ConfiguracaoNotificacao: Codable {
    var notificacoesAtivas: Bool = true
    var somPadrao: String = "default"
    var vibrar: Bool = true
    var mostrarBadge: Bool = true
    var manterHistorico: Bool = true
    var maxHistoricoDias: Int = 30
}
