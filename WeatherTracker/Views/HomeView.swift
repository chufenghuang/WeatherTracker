//
//  ContentView.swift
//  WeatherTracker
//
//  Created by Chufeng Huang on 1/29/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @FocusState private var isSearchFieldFocused: Bool // Track focus state for keyboard pop-up/dismiss
    
    // User's search text
    @State private var searchText: String = ""
    
    // Fetched data (nil if no results yet)
    @State private var cityName: String? = ""
    @State private var temperature: String? = nil
    @State private var humidity: String? = nil
    @State private var uv: String? = nil
    @State private var feelslike: String? = nil
    @State private var iconUrl: String? = nil
    
    // Error message if API call goes wrong
    @State private var errorMessage: String? = nil
    
    // Track if user has tapped the search result card (i.e., chosen a city)
    @State private var didSelectCity: Bool = false
    @State private var showSearchResultCard: Bool = false
    
    //View Models
    private let weatherService = WeatherAPIService()
    private let localStorage = LocalDataManager()
    
    var body: some View {
        VStack(spacing: 30) {
            // Search bar area
            HStack {
                TextField("Search Location", text: $searchText)
                    .searchFocused($isSearchFieldFocused)
                    .frame(height: 46)
                    .foregroundColor(Color("text_black"))
                    .focused($isSearchFieldFocused) // Bind focus state
                    .onSubmit {
                        // Dismiss the keyboard
                        isSearchFieldFocused = false
                        // Perform search
                        didSelectCity = false
                        Task {
                            await fetchWeather(targetCityName: searchText)
                        }
                    }
                Button(action: {
                   
                   Task {
                       didSelectCity = false
                       showSearchResultCard = true
                       await fetchWeather(targetCityName: searchText)
                      
                   }
               }) {
                   Image(systemName: "magnifyingglass") // Just the icon
                       .foregroundColor(Color("searchbar_icon_and_placeholder")) // Customize color if needed
               }            }
            .padding(.horizontal)
            .background(Color("card_background"))
            .cornerRadius(16)
            
            if didSelectCity {
                WeatherDashboardView(cityName: cityName!, temperature: temperature!, humidity: humidity!, uvIndex: uv!, feelsLike: feelslike!, iconUrl: iconUrl!)
            }else if let errorMessage = errorMessage{
                Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                        .onAppear {
                            print("DEBUG: UI displaying errorMessage = \(errorMessage)")
                        }
            }else if showSearchResultCard{
                    // Show the result card
                    SearchResultCardView(cityName: cityName!,
                                         temperature: temperature!,
                                         iconUrl: iconUrl!)
                    .onTapGesture {
                        localStorage.saveCityName(searchText)
                        searchText = ""
                        didSelectCity = true
                    }
            } else {
                Spacer()
                PlaceHolderView()
            }
           
            Spacer()
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity) // Expand to fill screen
        .contentShape(Rectangle()) // Make entire area tappable
        .onTapGesture {
            isSearchFieldFocused = false // Dismiss keyboard on tap
        }
        .onAppear {
            // 1) Check saved city on appear
            if let savedCity = localStorage.getSavedCityName(),
               !savedCity.isEmpty {
                // 2) Fetch weather for that city
                Task {
                    await fetchWeather(targetCityName: savedCity)
                    didSelectCity = true
                }
                
            }
        }
    }

    // MARK: - Fetch Logic
    private func fetchWeather(targetCityName:String) async {
        // 1. Clear previous data immediately before fetching
        cityName = nil
        temperature = nil
        humidity = nil
        uv = nil
        feelslike = nil
        iconUrl = nil
        showSearchResultCard = false // Hide previous result until new data arrives
        errorMessage = nil // Clear previous errors

        do {
           // 2. Perform the API call
           let response = try await weatherService.fetchCurrentWeather(for: targetCityName)
           print("RESPONSE is", response)

           // 3. Update state with new data
           cityName = response.location.name
           temperature = "\(Int(response.current.temp_c))"
           humidity = "\(response.current.humidity)%"
           uv = "\(response.current.uv)"
           feelslike = "\(response.current.feelslike_c)"

           let rawIcon = response.current.condition.icon
           iconUrl = rawIcon.hasPrefix("//") ? "https:" + rawIcon : rawIcon

           // 4. Show the result card after everything is ready
           showSearchResultCard = true

        } catch let error as WeatherAPIError {
            errorMessage = error.errorDescription // Set error message for UI
            showSearchResultCard = false // Hide results if error occurs
        } catch {
            errorMessage = "Unexpected error. Please try again."
            showSearchResultCard = false
        }
    }

}

#Preview {
    HomeView()
        
}
