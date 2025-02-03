//
//  ContentView.swift
//  WeatherTracker
//
//  Created by Chufeng Huang on 1/29/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @FocusState private var isSearchFieldFocused: Bool // Track focus state for keyboard pop-up/dismiss
    
    // User's search text
    @State private var searchText: String = ""
    
    
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
                        viewModel.setDidSelectCityValue(newValue: false)
                        Task {
                            await viewModel.fetchWeather(targetCityName: searchText)
                            await viewModel.fetchAstronomy(targetCityName: searchText)
                        }
                    }
                Button(action: {
                   Task {
                       viewModel.setDidSelectCityValue(newValue: false)
                       viewModel.setShowSearchResultCardValue(newValue: true)
                       viewModel.saveCityNameToLocalStorage(newCityName: searchText)
                       await viewModel.fetchWeather(targetCityName: searchText)
                       await viewModel.fetchAstronomy(targetCityName: searchText)
                       
                   }
               }) {
                   Image(systemName: "magnifyingglass") // Just the icon
                       .foregroundColor(Color("searchbar_icon_and_placeholder")) // Customize color if needed
               }            }
            .padding(.horizontal)
            .background(Color("card_background"))
            .cornerRadius(16)
            
            if viewModel.didSelectCity {
                WeatherDashboardView(cityName: viewModel.cityName ?? "",
                                     temperature: viewModel.temperature ?? "",
                                     humidity: viewModel.humidity ?? "",
                                     uvIndex: viewModel.uv ?? "",
                                     feelsLike: viewModel.feelslike ?? "",
                                     iconUrl: viewModel.iconUrl ?? "",
                                     sunrise: viewModel.sunrise ?? "",
                                     sunset: viewModel.sunset ?? ""
                )
            }else if let errorMessage = viewModel.errorMessage{
                Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                        .onAppear {
                            print("DEBUG: UI displaying errorMessage = \(errorMessage)")
                        }
            }else if viewModel.showSearchResultCard{
                    // Show the result card
                SearchResultCardView(cityName: viewModel.cityName ?? "",
                                     temperature: viewModel.temperature ?? "",
                                     iconUrl: viewModel.iconUrl ?? "")
                    .onTapGesture {
                        viewModel.selectCity(searchText)
                        searchText = ""
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

    }


}

#Preview {
    HomeView()
        
}
