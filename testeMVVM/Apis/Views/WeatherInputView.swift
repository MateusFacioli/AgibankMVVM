//
//  WeatherInputView.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 15/01/26.
//


import SwiftUI

struct WeatherInputView: View {
    let queryType: WeatherQueryType
    @State private var city: String = ""
    @State private var latText: String = ""
    @State private var lonText: String = ""
    @State private var navigate = false
    @State private var builtQuery: WeatherQueryType = .padrao

    var body: some View {
        Form {
            switch queryType {
            case .padrao:
                Text("Sem parâmetros adicionais. Use a sua key configurada em ApiConfig.")
            case .cidade:
                TextField("Cidade,UF (ex: Curitiba,PR)", text: $city)
                    .textInputAutocapitalization(.words)
                    .autocorrectionDisabled()
            case .coordenadas:
                TextField("Latitude (ex: -23.5505)", text: $latText)
                    .keyboardType(.decimalPad)
                TextField("Longitude (ex: -46.6333)", text: $lonText)
                    .keyboardType(.decimalPad)
            }

            NavigationLink(destination: WeatherResultView(query: builtQuery), isActive: $navigate) { EmptyView() }
        }
        .navigationTitle("Parâmetros")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Buscar") {
                    buildQueryAndNavigate()
                }
            }
        }
        .onAppear {
            switch queryType {
            case .cidade(let nome):
                city = nome
            case .coordenadas(let lat, let lon):
                latText = String(lat)
                lonText = String(lon)
            case .padrao:
                break
            }
            builtQuery = queryType
        }
    }

    private func buildQueryAndNavigate() {
        switch queryType {
        case .padrao:
            builtQuery = .padrao
            navigate = true
        case .cidade:
            let trimmed = city.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmed.isEmpty else { return }
            builtQuery = .cidade(nome: trimmed)
            navigate = true
        case .coordenadas:
            guard let lat = Double(latText.replacingOccurrences(of: ",", with: ".")),
                  let lon = Double(lonText.replacingOccurrences(of: ",", with: ".")) else { return }
            builtQuery = .coordenadas(lat: lat, lon: lon)
            navigate = true
        }
    }
}

#Preview {
    NavigationStack { WeatherInputView(queryType: .cidade(nome: "Curitiba,PR")) }
}
