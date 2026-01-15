//
//  WeatherService.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 15/01/26.
//


import Foundation

/// Serviço simples para consumo da API de clima
struct WeatherService {

    enum ServiceError: Error {
        case invalidURL
        case badResponse
        case decoding(Error)
    }

    /// Monta a URL a partir do tipo de consulta
    func makeURL(for query: WeatherQueryType) -> URL? {
        var components = URLComponents(url: ApiConfig.baseURL, resolvingAgainstBaseURL: false)
        var items: [URLQueryItem] = [URLQueryItem(name: "key", value: ApiConfig.apiKey)]
        switch query {
        case .padrao:
            break
        case .cidade(let nome):
            items.append(URLQueryItem(name: "city_name", value: nome))
        case .coordenadas(let lat, let lon):
            items.append(URLQueryItem(name: "lat", value: String(lat)))
            items.append(URLQueryItem(name: "lon", value: String(lon)))
        }
        components?.queryItems = items
        return components?.url
    }

    /// Faz a requisição e decodifica o resultado
    func fetch(_ query: WeatherQueryType) async throws -> WeatherResponse {
        guard let url = makeURL(for: query) else { throw ServiceError.invalidURL }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let http = response as? HTTPURLResponse, 200..<300 ~= http.statusCode else {
            throw ServiceError.badResponse
        }
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(WeatherResponse.self, from: data)
            return result
        } catch {
            throw ServiceError.decoding(error)
        }
    }
}
