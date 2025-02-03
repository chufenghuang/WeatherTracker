//
//  WeatherAPIService.swift
//  WeatherTracker
//
//  Created by Chufeng Huang on 1/29/25.
//

import Foundation

// MARK: - Protocol

protocol WeatherAPIServiceProtocol {
    func fetchCurrentWeather(for city: String) async throws -> WeatherResponse
    func fetchAstronomy(for city: String) async throws -> AstronomyResponse
}

// MARK: - Service Implementation

class WeatherAPIService: WeatherAPIServiceProtocol {

    private let apiKey: String
    private let session: URLSession

    // MARK: - Initializer
    init(apiKey: String = "becbadc1362647bea7a184232252901",
         session: URLSession = .shared) {
        self.apiKey = apiKey
        self.session = session
    }

    // MARK: - Public Methods

    /// Fetches the current weather for a given city using the WeatherAPI.
    /// - Parameter city: City name or location string (e.g. "London", "New York", "Chicago").
    /// - Returns: A `WeatherResponse` model containing location and current weather details.
    func fetchCurrentWeather(for city: String) async throws -> WeatherResponse {
        guard let url = makeCurrentWeatherURL(for: city) else {
            throw WeatherAPIError.invalidURL
        }

        do {
            let (data, response) = try await session.data(from: url)

            // Print response for debugging
            if let httpResponse = response as? HTTPURLResponse {
                print("The httpResponse.statusCode is \(httpResponse.statusCode)")

                // Stop execution immediately if status code is 400**
                if httpResponse.statusCode == 400 {
                    throw WeatherAPIError.invalidCity
                }
                // Handle other server errors (non-200 responses)
                if !(200...299).contains(httpResponse.statusCode) {
                    throw WeatherAPIError.requestFailed(statusCode: httpResponse.statusCode)
                }
            }

            return try JSONDecoder().decode(WeatherResponse.self, from: data)

        } catch let error as URLError {
            if error.code == .notConnectedToInternet {
                throw WeatherAPIError.noInternet
            } else {
                throw WeatherAPIError.unknown
            }
        } catch let decodingError {
            throw WeatherAPIError.decodingError(decodingError)
        }
    }
    
    func fetchAstronomy(for city: String) async throws -> AstronomyResponse {
        guard let url = makeAstronomyURL(for: city) else {
            throw WeatherAPIError.invalidURL
        }

        do {
            let (data, response) = try await session.data(from: url)

            // Print response for debugging
            if let httpResponse = response as? HTTPURLResponse {
                print("The httpResponse.statusCode is \(httpResponse.statusCode)")

                // Stop execution immediately if status code is 400**
                if httpResponse.statusCode == 400 {
                    throw WeatherAPIError.invalidCity
                }
                // Handle other server errors (non-200 responses)
                if !(200...299).contains(httpResponse.statusCode) {
                    throw WeatherAPIError.requestFailed(statusCode: httpResponse.statusCode)
                }
            }

            return try JSONDecoder().decode(AstronomyResponse.self, from: data)

        } catch let error as URLError {
            if error.code == .notConnectedToInternet {
                throw WeatherAPIError.noInternet
            } else {
                throw WeatherAPIError.unknown
            }
        } catch let decodingError {
            throw WeatherAPIError.decodingError(decodingError)
        }
    }
    

    // MARK: - Helper Methods
    // documentation: https://www.weatherapi.com/api-explorer.aspx
    private func makeCurrentWeatherURL(for city: String) -> URL? {
        var urlComponents = URLComponents(string: "https://api.weatherapi.com/v1/current.json")
        urlComponents?.queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "q", value: city)
        ]
        return urlComponents?.url
    }
    
    private func makeAstronomyURL(for city: String) -> URL? {
        var urlComponents = URLComponents(string: "https://api.weatherapi.com/v1/astronomy.json")
        urlComponents?.queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "q", value: city)
        ]
        return urlComponents?.url
    }
}

// MARK: - WeatherAPIError

enum WeatherAPIError: Error, LocalizedError {
    case invalidURL
    case noInternet
    case invalidCity
    case requestFailed(statusCode: Int)
    case decodingError(Error)
    case unknown

    var errorDescription: String? {
      switch self {
      case .invalidURL:
          return "Invalid request. Please try again."
      case .noInternet:
          return "No internet connection. Please check your network and try again."
      case .invalidCity:
          return "City not found. Please enter a valid city name."
      case .requestFailed(let statusCode):
          return "Server error (code \(statusCode)). Please try again later."
      case .decodingError:
          return "Failed to load weather data. Please try again."
      case .unknown:
          return "Something went wrong. Please try again."
      }
    }
}

struct WeatherAPIErrorResponse: Codable {
    let error: WeatherAPIErrorDetail
}

struct WeatherAPIErrorDetail: Codable {
    let code: Int
    let message: String
}
