//
//  WeatherResponse.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 15/01/26.
//


import Foundation

/// Modelo do response principal da API de clima HG Brasil
struct WeatherResponse: Decodable {
    /// Fonte dos dados
    let by: String
    /// Indica se a chave de API é válida
    let validKey: Bool
    /// Dados de clima retornados
    let results: WeatherResults
    /// Tempo de execução da requisição (ms)
    let executionTime: Int
    /// Indica se os dados vieram do cache
    let fromCache: Bool

    enum CodingKeys: String, CodingKey {
        case by
        case validKey = "valid_key"
        case results
        case executionTime = "execution_time"
        case fromCache = "from_cache"
    }
}

/// Dados principais de clima retornados pelo endpoint
struct WeatherResults: Decodable {
    /// Temperatura atual
    let temp: Int
    /// Data do dado
    let date: String
    /// Hora do dado
    let time: String
    /// Código da condição do tempo
    let conditionCode: String
    /// Descrição da condição do tempo
    let description: String
    /// Estado atual do tempo
    let currently: String
    /// WOEID da localidade
    let woeid: Int
    /// Nome da cidade
    let city: String
    /// Identificador da imagem do tempo
    let imgID: String
    /// Umidade em %
    let humidity: Int
    /// Cobertura de nuvens em %
    let cloudiness: Int
    /// Chuva em mm
    let rain: Double
    /// Velocidade do vento com unidade
    let windSpeedy: String
    /// Direção do vento em graus
    let windDirection: Int
    /// Direção do vento em texto
    let windCardinal: String
    /// Horário do nascer do sol
    let sunrise: String
    /// Horário do pôr do sol
    let sunset: String
    /// Fase da lua
    let moonPhase: String
    /// Slug da condição do tempo
    let conditionSlug: String
    /// Nome da cidade (repetido)
    let cityName: String
    /// Fuso horário
    let timezone: String
    /// Lista de previsões
    let forecast: [WeatherForecast]
    /// Código CREF
    let cref: String
    /// Latitude da localidade
    let latitude: Double
    /// Longitude da localidade
    let longitude: Double

    enum CodingKeys: String, CodingKey {
        case temp, date, time, description, currently, woeid, city, humidity, cloudiness, rain, sunrise, sunset, forecast, cref, latitude, longitude
        case conditionCode = "condition_code"
        case imgID = "img_id"
        case windSpeedy = "wind_speedy"
        case windDirection = "wind_direction"
        case windCardinal = "wind_cardinal"
        case moonPhase = "moon_phase"
        case conditionSlug = "condition_slug"
        case cityName = "city_name"
        case timezone
    }
}

/// Previsão diária
struct WeatherForecast: Decodable, Identifiable {
    /// Identificador único da previsão (data completa + dia da semana)
    var id: String { fullDate + "-" + weekday }

    /// Data no formato curto
    let date: String
    /// Data no formato completo
    let fullDate: String
    /// Dia da semana
    let weekday: String
    /// Temperatura máxima
    let max: Int
    /// Temperatura mínima
    let min: Int
    /// Umidade em %
    let humidity: Int
    /// Cobertura de nuvens em %
    let cloudiness: Int
    /// Chuva em mm
    let rain: Double
    /// Probabilidade de chuva em %
    let rainProbability: Int
    /// Velocidade do vento com unidade
    let windSpeedy: String
    /// Horário do nascer do sol
    let sunrise: String
    /// Horário do pôr do sol
    let sunset: String
    /// Fase da lua
    let moonPhase: String
    /// Descrição da condição do tempo
    let description: String
    /// Código da condição do tempo
    let condition: String

    enum CodingKeys: String, CodingKey {
        case date, weekday, max, min, humidity, cloudiness, rain, sunrise, sunset, description, condition
        case fullDate = "full_date"
        case rainProbability = "rain_probability"
        case windSpeedy = "wind_speedy"
        case moonPhase = "moon_phase"
    }
}
