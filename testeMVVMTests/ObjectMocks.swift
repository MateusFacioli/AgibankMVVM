//
//  ObjectMocks.swift
//  testeMVVMTests
//
//  Created by Mateus Rodrigues on 12/01/26.
//

import Foundation

struct STOCKMODELMOCK: Codable, Equatable {
    let prateleira: Int = 0
    let local_galpao: String = "mockado"
    let andar: Int = 0
    let setor: Int = 0
    let depto: String = "mockado"
    let id_item: String = "mockado"
    let id_galpao: Int = 0
    
    enum CodingKeys: CodingKey {
        case prateleira
        case local_galpao
        case andar
        case setor
        case depto
        case id_item
        case id_galpao
    }
}

struct StockViewModelMOCK {
    func cadastrarGalpaoMock(mock: STOCKMODELMOCK) -> STOCKMODELMOCK {
        return mock
    }
    func removerGalpaoMock() {}
    func atualizarGalpaoMock() {}
    func consultarGalpaoMock() {}
}
