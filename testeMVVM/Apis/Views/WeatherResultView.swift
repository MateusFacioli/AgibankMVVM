//
//  WeatherResultView.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 15/01/26.
//


import SwiftUI

struct WeatherResultView: View {
    let query: WeatherQueryType
    @State private var response: WeatherResponse?
    @State private var isLoading = false
    @State private var errorMessage: String?

    private let service = WeatherService()

    var body: some View {
        Group {
            if isLoading {
                ProgressView("Carregando...")
            } else if let errorMessage {
                VStack(spacing: 12) {
                    Text("Erro")
                        .font(.headline)
                    Text(errorMessage)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    Button("Tentar novamente") { Task { await load() } }
                }
                .padding()
            } else if let response {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        let r = response.results
                        Text("Cidade: \(r.city)")
                            .font(.title2)
                            .bold()
                        Text("Agora: \(r.temp)°C | \(r.description.capitalized)")
                        Text("Vento: \(r.windSpeedy)  •  Umidade: \(r.humidity)%")
                        Text("Nascer do sol: \(r.sunrise)  •  Pôr do sol: \(r.sunset)")

                        Divider()
                        Text("Previsão")
                            .font(.headline)

                        ForEach(r.forecast) { day in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("\(day.weekday) • \(day.fullDate)")
                                        .font(.subheadline)
                                    Text(day.description.capitalized)
                                        .foregroundStyle(.secondary)
                                        .font(.footnote)
                                }
                                Spacer()
                                VStack(alignment: .trailing) {
                                    Text("Max \(day.max)°  Min \(day.min)°")
                                        .font(.subheadline)
                                    Text("Chuva: \(Int(day.rainProbability))%")
                                        .foregroundStyle(.secondary)
                                        .font(.footnote)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .padding()
                }
            } else {
                Text("Sem dados")
                    .foregroundStyle(.secondary)
                    .padding()
            }
        }
        .navigationTitle("Resultado")
        .task { await load() }
    }

    private func load() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            response = try await service.fetch(query)
        } catch {
            errorMessage = String(describing: error)
        }
    }
}

#Preview {
    NavigationStack { WeatherResultView(query: .padrao) }
}
