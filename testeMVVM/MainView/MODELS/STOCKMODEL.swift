//
//  STOCKMODEL.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 08/01/26.

import SwiftUI
import Foundation
import MapKit
import CoreLocation

/// Estrutura de um objeto real que estamos codificando e tipificando
struct STOCKMODEL: Codable, Equatable {
    var prateleira: Int?
    var local_galpao: LocationCoordinateModel?
    var andar: Int?
    var setor: Int?
    var depto: String?
    var id_item: String
    var id_galpao: Int
    
    enum CodingKeys: String, CodingKey {
        case prateleira
        case local_galpao
        case andar
        case setor
        case depto
        case id_item
        case id_galpao
    }

}
