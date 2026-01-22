//
//  Usuario.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 22/01/26.
//

import Foundation

/// Modelo de dados para usuário
struct Usuario: Identifiable, Codable {
    let id: UUID
    var nome: String
    var email: String
    var idade: Int
    var ativo: Bool
    
    init(id: UUID = UUID(), nome: String = "", email: String = "", idade: Int = 0, ativo: Bool = true) {
        self.id = id
        self.nome = nome
        self.email = email
        self.idade = idade
        self.ativo = ativo
    }
    
    /// Descrição simplificada
    var descricao: String {
        return "\(nome) (\(idade) anos) - \(ativo ? "Ativo" : "Inativo")"
    }
}
