//
//  MapsCoordinator.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 13/01/26.
//


import Foundation
import SwiftUI
import Combine

// Routes específicos de Maps
enum MapsSheetRoute: Identifiable, Equatable {
    case locationCallback
    case locationShared
    case locationBinding

    var id: String {
        switch self {
        case .locationCallback: return "locationCallback"
        case .locationShared: return "locationShared"
        case .locationBinding: return "locationBinding"
        }
    }
}

final class MapsCoordinator: ObservableObject {
    // Apresentação via sheet
    @Published var activeSheet: MapsSheetRoute? = nil

    // Dependências opcionais (injeção)
    @Published var sharedLocationVM: LocationViewModel = LocationViewModel()

    // Canalização de resultado (coordenada escolhida)
    @Published var pickedCoordinate: LocationCoordinateModel? = nil

    // Métodos de intenção
    func presentCallback() { activeSheet = .locationCallback }
    func presentSharedVM() { activeSheet = .locationShared }
    func presentBinding() { activeSheet = .locationBinding }

    func dismiss() { activeSheet = nil }
}
