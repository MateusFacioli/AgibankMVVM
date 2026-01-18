//
//  Evento.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 18/01/26.
//


import Foundation
internal import EventKit

// Modelo para representar um evento do calendário
struct Evento: Identifiable {
    let id = UUID()
    var titulo: String
    var descricao: String
    var dataInicio: Date
    var dataFim: Date
    var local: String
    
    // Converte nosso modelo para o modelo do EventKit
    func toEKEvent(store: EKEventStore) -> EKEvent {
        let evento = EKEvent(eventStore: store)
        evento.title = titulo
        evento.notes = descricao
        evento.startDate = dataInicio
        evento.endDate = dataFim
        evento.location = local
        evento.calendar = store.defaultCalendarForNewEvents
        
        return evento
    }
}
