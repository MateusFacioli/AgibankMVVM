//
//  ApiConfig.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 14/01/26.
//

import Foundation

/// ARQUIVO DE CONFIGURAÇÃO PADRÃO
/// Copiar esse arquivo para `Api/ApiConfig.swift` e ajustar se precisar
/// O arquivo real `ApiConfig.swift` não deverá ser commitado no git.
struct ApiConfig {
    /// URL base para a API de clima (HG Brasil)
    static let baseURL = URL(string: "https://api.hgbrasil.com/weather")!

    /// Chave pública da API
    static let apiKey = "4e724186"
}

/// Alguns endpoints antigos podiam retornar vetores diretamente, mantendo aqui um wrapper genérico caso necessário em outros pontos
struct APIList<T: Decodable>: Decodable {
    let data: [T]
}

/// Tipos de consulta possíveis para a API de clima
enum WeatherQueryType: Equatable {
    case padrao // somente com a key
    case cidade(nome: String) // city_name
    case coordenadas(lat: Double, lon: Double) // lat & lon
}
