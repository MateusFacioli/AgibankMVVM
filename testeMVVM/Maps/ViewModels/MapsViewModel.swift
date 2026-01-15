//
//  MapsViewModel.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 15/01/26.
//


import Foundation
import CoreLocation
import Combine

/// ViewModel para o mini projeto de Mapas
/// Responsável por: estado selecionado, cidade, coordenadas e ações de atualização
final class MapsViewModel: ObservableObject {
    /// Cidade selecionada (exibição)
    @Published var selectedCity: String = ""
    /// Coordenada selecionada (se disponível)
    @Published var coordinate: LocationCoordinateModel? = nil
    /// Precisão ou descrição adicional
    @Published var accuracyDescription: String = ""

    /// Exemplo de lista de cidades (mock) para um dropdown simples
    let cities: [String] = [
        "São Paulo, SP",
        "Curitiba, PR",
        "Rio de Janeiro, RJ",
        "Belo Horizonte, MG",
        "Porto Alegre, RS"
    ]

    /// Seleciona cidade por índice e atualiza estado interno
    func selectCity(at index: Int) {
        guard cities.indices.contains(index) else { return }
        selectedCity = cities[index]
        // Em um app real: geocodificar a cidade -> coordenada
        // Aqui apenas limpamos a coordenada como placeholder
        coordinate = nil
        accuracyDescription = "Cidade selecionada: \(selectedCity)"
    }

    /// Atualiza a coordenada manualmente (ex.: input do usuário)
    func updateCoordinate(lat: Double, lon: Double) {
        coordinate = LocationCoordinateModel(latitude: lat, longitude: lon)
        accuracyDescription = "Coordenada definida manualmente"
    }
}
