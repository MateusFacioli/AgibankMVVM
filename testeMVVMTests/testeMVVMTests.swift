//
//  testeMVVMTests.swift
//  testeMVVMTests
//
//  Created by Mateus Rodrigues on 08/01/26.
//

import Testing
import XCTest
@testable import testeMVVM


struct testeMVVMTests {
    let mock = STOCKMODELMOCK()
    let naomockado = StockModel(id_item: "", id_galpao: 0)
    let resultado = StockViewModelMOCK()

    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }
    //given
    //when
    //then
    @Test func cadastrarGalpaoTest() {
        let chamada = resultado.cadastrarGalpaoMock(mock: mock)
        let chamada2 = StockViewModel(stock: naomockado)
        XCTAssertEqual(chamada2.cadastrarGalpao(naomockado), naomockado)
        XCTAssertTrue(chamada == mock)
    }
    
    /**
     func cadastrarGalpao(_ objeto: StockModel) -> StockModel {
         self.stock = objeto
         galpoes.append(stock)
         return stock
     }
     */

}
