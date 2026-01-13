//
//  STOCKMODEL.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 08/01/26.
import Foundation

/// Estrtura de um objeto real que estamos codificando e tipificando
struct StockModel: Codable {
    
    var prateleira: Int
    var localGalpao: String
    var andar: Int
    var setor: Int
    var departamento: String
    var idGalpao: Int
    
    var location: LocationModel?
    
    /// Inicializador padrão (vazio)
     init() {
         self.prateleira = 0
         self.localGalpao = ""
         self.andar = 0
         self.setor = 0
         self.departamento = ""
         self.idGalpao = 0
     }

     /// Inicializador completo (para criar/editar)
     init(
         prateleira: Int,
         localGalpao: String,
         andar: Int,
         setor: Int,
         departamento: String,
         idGalpao: Int
     ) {
         self.prateleira = prateleira
         self.localGalpao = localGalpao
         self.andar = andar
         self.setor = setor
         self.departamento = departamento
         self.idGalpao = idGalpao
     }

}
