//
//  StockViewModel.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 08/01/26.
//

import Foundation
import CoreData
import Combine


final class StockViewModel: ObservableObject {
    
   @Published var stock: StockModel
   @Published var galpoes: [StockModel] = []
   @Published  var idGalpao = 0
    
    init(stock: StockModel) {
        self.stock = stock
    }
    
    func cadastrarGalpao(_ objeto: StockModel) -> StockModel {
        self.stock = objeto
        galpoes.append(stock)
        return stock
    }
    
    func removerGalpao(idGalpaoparam: Int) {
        idGalpao = idGalpaoparam
        if let index = galpoes.firstIndex(where: { $0.id_galpao == idGalpao }) {
            galpoes.remove(at: index)
        } else {
            print("VETOR DE GALPAO VAZIO OU ID NAO ENCONTRADO")
        }
    }
    
    func atualizarGalpao(idGalpaoparam: Int) -> StockModel? {
        idGalpao = idGalpaoparam
        if let index = galpoes.firstIndex(where: { $0.id_galpao == idGalpao }) {
            var updated = galpoes[index]
            updated.andar = stock.andar
            updated.local_galpao = stock.local_galpao
            updated.depto = stock.depto
            updated.prateleira = stock.prateleira
            updated.setor = stock.setor
            updated.id_item = stock.id_item
            galpoes[index] = updated
            return updated
        } else {
            return nil
        }
    }
    
    // MARK: - Location integration helpers
    func updateLocationWithCallback(_ coordinate: LocationCoordinateModel) {
        self.stock.local_galpao = coordinate
    }

    // shared LocationViewModel pattern: keep a single instance that screens can use
    @Published var sharedLocationVM: LocationViewModel = LocationViewModel()

    func updateLocationFromSharedVM() {
        if let coord = sharedLocationVM.savedCoordinate {
            self.stock.local_galpao = coord
        }
    }
    // binding-based update
    func updateLocationBinding(_ coordinate: LocationCoordinateModel?) {
        self.stock.local_galpao = coordinate
    }
}

