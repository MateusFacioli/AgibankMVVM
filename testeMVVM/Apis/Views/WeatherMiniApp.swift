//
//  WeatherMiniApp.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 15/01/26.
//


import SwiftUI

enum QueryType {
    case padrao
    case cidade(nome: String)
    case coordenadas(lat: Double, lon: Double)
}


/// Ponto de entrada do mini projeto de API de clima
struct WeatherMiniApp: View {
    var body: some View {
        NavigationStack {
            WeatherStartView()
                .navigationTitle("Clima (HG Brasil)")
        }
    }
}

struct WeatherStartView: View {
    var body: some View {
        List {
            Section("Consultas") {
                NavigationLink("Consulta padrão (somente key)") {
                    WeatherInputView(queryType: .padrao)
                }
                NavigationLink("Por cidade (city_name)") {
                    WeatherInputView(queryType: .cidade(nome: ""))
                }
                NavigationLink("Por coordenadas (lat/lon)") {
                    WeatherInputView(queryType: .coordenadas(lat: 0, lon: 0))
                }
            }
        }
    }
}

#Preview {
    WeatherMiniApp()
}
