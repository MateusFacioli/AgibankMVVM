//
//  LocationView.swift
//  testeMVVM
//
//  Created by Maurício Fonseca on 13/01/26.
//

import SwiftUI
import MapKit

struct LocationView: View {
    // Default internal VM when not provided
    @StateObject private var internalVM = LocationViewModel()
    // Optional external VM for shared ViewModel approach
    var externalVM: LocationViewModel?
    // Optional callback when a coordinate is picked
    var onLocationPicked: ((LocationModel) -> Void)?
    // Optional binding for two-way updates
    @Binding var selectedCoordinate: LocationModel?
    private var vm: LocationViewModel { externalVM ?? internalVM }

    init(externalVM: LocationViewModel? = nil,
         onLocationPicked: ((LocationModel) -> Void)? = nil,
         selectedCoordinate: Binding<LocationModel?> = .constant(nil)) {
        self.externalVM = externalVM
        self.onLocationPicked = onLocationPicked
        self._selectedCoordinate = selectedCoordinate
    }

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                TextField("Digite o nome da cidade", text: externalVM == nil ? $internalVM.cityName : .constant(vm.cityName))
                    .textFieldStyle(.roundedBorder)
                    .submitLabel(.search)
                    .onSubmit {
                        Task { await vm.geocodeCityAndUpdateMap() }
                    }

                if vm.isGeocoding {
                    ProgressView()
                        .padding(.leading, 4)
                }
            }

            if let error = vm.geocodeErrorMessage {
                Text(error)
                    .foregroundStyle(.red)
            }

            // Mapa vinculado à região
            Map(position: .constant(.region(vm.mapRegion))) // iOS 18+ API
                .mapControls {
                    MapUserLocationButton()
                    MapCompass()
                    MapScaleView()
                }
                .frame(minHeight: 300)
            
            if let saved = vm.savedCoordinate {
                Text("Coordenada salva: \(saved.latitude), \(saved.longitude)")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            if let saved = vm.savedCoordinate {
                Text("Coordenada salva: \(saved.latitude), \(saved.longitude)")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Button("Usar esta localização") {
                if let saved = vm.savedCoordinate {
                    // callback
                    onLocationPicked?(saved)
                    // binding
                    selectedCoordinate = saved
                }
            }
            .buttonStyle(.bordered)

            // Botão opcional para forçar busca
            Button("Buscar cidade") {
                Task { await vm.geocodeCityAndUpdateMap() }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
