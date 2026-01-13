//
//  LocationViewModel.swift
//  testeMVVM
//
//  Created by Maurício Fonseca on 13/01/26.
//

import Foundation
import MapKit
import CoreLocation
import Combine

@MainActor
final class LocationViewModel: ObservableObject {
    @Published var cityName: String = ""
    @Published var mapRegion: MKCoordinateRegion = .init(
        center: CLLocationCoordinate2D(latitude: -15.793889, longitude: -47.882778), // Centro: Brasília (exemplo)
        span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)//zoom
    )
    @Published var savedCoordinate: LocationModel? = nil
    @Published var isGeocoding: Bool = false
    @Published var geocodeErrorMessage: String? = nil

    // adicionando que salve o nome da cidade
    @Published var placeName: String = ""

    
    private let geocoder = CLGeocoder()
    
    func geocodeCityAndUpdateMap() async {
        let query = cityName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return }

        isGeocoding = true
        geocodeErrorMessage = nil
        defer { isGeocoding = false }

        do {
            // CLGeocoder tem API async/await em iOS recentes. Alternativa: completion handler.
            let placemarks = try await geocoder.geocodeAddressString(query)
            guard let first = placemarks.first, let coord = first.location?.coordinate else {
                geocodeErrorMessage = "Não foi possível encontrar a cidade."
                return
            }

            // Atualiza região do mapa (zoom adequado)
            mapRegion = MKCoordinateRegion(
                center: coord,
                span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
            )

            // Salva a coordenada no model
            savedCoordinate = LocationModel(latitude: coord.latitude, longitude: coord.longitude)
            
            let model = LocationModel(
                latitude: coord.latitude,
                longitude: coord.longitude
            )
            await resolvePlaceName(from: model)

        } catch {
            geocodeErrorMessage = "Erro ao buscar localização: \(error.localizedDescription)"
        }
    }
    
    private func resolvePlaceName(from coordinate: LocationModel) async {
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(
                CLLocation(latitude: coordinate.latitude,
                           longitude: coordinate.longitude)

            )

            guard let placemark = placemarks.first else { return }

            if let city = placemark.locality {
                placeName = city
            } else if let name = placemark.name {
                placeName = name
            } else {
                placeName = "Local selecionado"
            }

        } catch {
            placeName = "Local selecionado"
        }
    }

}
