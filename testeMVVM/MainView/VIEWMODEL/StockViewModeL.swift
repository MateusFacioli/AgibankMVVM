//
//  STOCKVIEWMODEL.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 08/01/26.
//

import Foundation
import CoreData
import Combine


final class StockViewModel: ObservableObject {
    
    // Formulário como String
    @Published var idGalpao = ""
    @Published var andar = ""
    @Published var setor = ""
    @Published var prateleira = ""
    @Published var localGalpao = ""
    @Published var departamento = ""
    
    @Published var location: LocationModel? = nil
    
    @Published var galpoes: [StockModel] = []
    
    @Published var searchId: String = ""
    
    func setLocation(_ location: LocationModel, displayName: String) {
        self.location = location
        self.localGalpao = displayName
    }
    
    func cadastrarGalpao(){
        let stock = StockModel(
            prateleira: Int(prateleira) ?? 0,
            localGalpao: localGalpao,
            andar: Int(andar) ?? 0,
            setor: Int(setor) ?? 0,
            departamento: departamento,
            idGalpao: Int(idGalpao) ?? 0
        )
        
        galpoes.append(stock)
        limparFormulario()
    }
    
    func todosGalpoes() -> [StockModel]{
        return galpoes
    }
    
    func buscarPorId() -> StockModel?{
        var find: StockModel = StockModel()
        
        for galpao in galpoes {
            if galpao.idGalpao == Int(searchId){
                find = galpao
                return find
            }
        }
        return nil
    }
    
    func removerGalpao(idGalpao: Int) {
        galpoes.removeAll{$0.idGalpao == idGalpao}
    }
    
    
    private func limparFormulario(){
        prateleira = ""
        localGalpao =  ""
        andar = ""
        setor = ""
        departamento = ""
        idGalpao = ""
    }
}


