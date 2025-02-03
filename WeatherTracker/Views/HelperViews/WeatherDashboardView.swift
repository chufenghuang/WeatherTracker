//
//  WeatherDashboardView.swift
//  WeatherTracker
//
//  Created by Chufeng Huang on 1/29/25.
//

import SwiftUI

struct WeatherDashboardView: View {
    // MARK: - Parameters
    let cityName: String
    let temperature: String
    let humidity: String
    let uvIndex: String
    let feelsLike: String
    let iconUrl: String
    
    let sunrise: String
    let sunset: String
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 30){
                // Top weather icon
                AsyncImage(url: URL(string: iconUrl)) { phase in
                    switch phase {
                        case .empty:
                            // Loading placeholder
                            ProgressView()
                                .frame(width:120, height: 120)
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(height: 120)
                        case .failure:
                            // Fallback if image fails
                            Image(systemName: "exclamationmark.triangle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .foregroundColor(.red)
                        @unknown default:
                            EmptyView()
                    }
                }
                
                // City name + arrow icon
                HStack(spacing: 8) {
                    Text(cityName)
                        .font(.custom("Poppins", size: 32))
                        .fontWeight(.semibold)
                        .frame(height: 20)
                    Image(systemName: "location.fill")
                        .resizable()
                        .frame(width:20,height: 20)
                }
                
                // Big temperature
                HStack{
                    Text(temperature)
                        .font(.custom("Poppins-Medium", size: 70))
                    VStack{
                        Image(systemName: "circle")
                            .resizable()
                            .frame(width: 6,height: 6)
                        Spacer()
                    }
                }.frame(height: 60)
            }

            // Rounded info bar
            HStack(spacing: 32) {
                // Humidity
                VStack(spacing: 8) {
                    Text("Humidity")
                        .font(.custom("Poppins", size: 12))
                        .foregroundColor(Color("text_third_gray"))
                    Text(humidity)  // e.g. "20%"
                        .font(.custom("Poppins", size: 18))
                        .foregroundColor(Color("text_secondry_gray"))
                }
                .frame(width: 60)
                
                // UV
                VStack(spacing: 8) {
                    Text("UV")
                        .font(.custom("Poppins", size: 12))
                        .foregroundColor(Color("text_third_gray"))
                    Text(uvIndex)  // e.g. "4"
                        .font(.custom("Poppins", size: 18))
                        .foregroundColor(Color("text_secondry_gray"))
                }
                .frame(width: 60)
                
                // Feels Like
                VStack(spacing: 8) {
                    Text("Feels Like")
                        .font(.custom("Poppins", size: 12))
                        .foregroundColor(Color("text_third_gray"))
                    Text("\(feelsLike)°")
                        .font(.custom("Poppins", size: 18))
                        .foregroundColor(Color("text_secondry_gray"))
                }
                .frame(width: 60)
            }
            .frame(width: 280,height: 75)
            .padding(.vertical, 8)
            .padding(.horizontal, 8)
            .background(Color("card_background"))
            .cornerRadius(16)
            
            HStack{
                VStack(spacing: 8) {
                    Text("Sunrise")
                        .font(.custom("Poppins", size: 12))
                        .foregroundColor(Color("text_third_gray"))
                    Text(sunrise)
                        .font(.custom("Poppins", size: 18))
                        .foregroundColor(Color("text_secondry_gray"))
                }
//                .frame(width: 60)
                Spacer()
                VStack(spacing: 8) {
                    Text("Sunset")
                        .font(.custom("Poppins", size: 12))
                        .foregroundColor(Color("text_third_gray"))
                    Text(sunset)
                        .font(.custom("Poppins", size: 18))
                        .foregroundColor(Color("text_secondry_gray"))
                }
//                .frame(width: 60)
            }
            .padding()
            .frame(width: 280)
        }
        .padding()
    }
}

#Preview {
    WeatherDashboardView(cityName: "Chicago", temperature: "19", humidity: "20%", uvIndex: "4", feelsLike: "34", iconUrl: "https://cdn.weatherapi.com/weather/64x64/day/116.png", sunrise: "07:36 AM", sunset: "04:54 PM")
}
