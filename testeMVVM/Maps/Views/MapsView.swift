//
//  MapsView.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 15/01/26.
//


import SwiftUI
import CoreLocation

/// View principal do mini projeto de Mapas (UI placeholder)
/// Mantém-se desacoplada de MapKit para este starter (foco no MVVM e inputs)
struct MapsView: View {
    @ObservedObject var viewModel: MapsViewModel
    @State private var selectedIndex: Int = 0
    @State private var latText: String = ""
    @State private var lonText: String = ""

    var body: some View {
        Form {
            Section("Cidade") {
                // Picker para seleção da cidade
                Picker("Selecione uma cidade", selection: $selectedIndex) {
                    ForEach(0..<viewModel.cities.count, id: \.self) { i in
                        Text(viewModel.cities[i]).tag(i)
                    }
                }
                .onChange(of: selectedIndex) { _, newValue in
                    viewModel.selectCity(at: newValue)
                    // Atualiza os textos dos campos de latitude e longitude quando a cidade muda
                    if let coord = viewModel.coordinate {
                        latText = String(coord.latitude)
                        lonText = String(coord.longitude)
                    } else {
                        latText = ""
                        lonText = ""
                    }
                }
                Text("Selecionada: \(viewModel.selectedCity.isEmpty ? "-" : viewModel.selectedCity)")
            }

            Section("Coordenadas") {
                // Campos para entrada manual de latitude e longitude
                TextField("Latitude", text: $latText)
                    .keyboardType(.decimalPad)
                TextField("Longitude", text: $lonText)
                    .keyboardType(.decimalPad)

                HStack {
                    Button("Definir coordenada") {
                        // Tenta converter texto para Double e atualizar a coordenada via ViewModel
                        if let lat = Double(latText.replacingOccurrences(of: ",", with: ".")),
                           let lon = Double(lonText.replacingOccurrences(of: ",", with: ".")) {
                            viewModel.updateCoordinate(lat: lat, lon: lon)
                        }
                    }
                    Spacer()
                    // Placeholder para zoom (sem integração real)
                    Button("Zoom +") {
                        // Apenas placeholder, não faz nada por ora
                    }
                }

                // Exibe a coordenada atual se disponível
                if let coord = viewModel.coordinate {
                    Text("Coordenada: \(coord.latitude), \(coord.longitude)")
                } else {
                    Text("Coordenada: -")
                        .foregroundStyle(.secondary)
                }

                // Mostra descrição da precisão, se houver
                if !viewModel.accuracyDescription.isEmpty {
                    Text(viewModel.accuracyDescription)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .onAppear {
            // Inicializa o picker e os textos com a cidade e coordenada atuais do ViewModel
            if let index = viewModel.cities.firstIndex(of: viewModel.selectedCity) {
                selectedIndex = index
            } else {
                selectedIndex = 0
                viewModel.selectCity(at: 0)
            }
            if let coord = viewModel.coordinate {
                latText = String(coord.latitude)
                lonText = String(coord.longitude)
            }
        }
    }
}

#Preview {
    MapsView(viewModel: MapsViewModel())
}
