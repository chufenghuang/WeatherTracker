//
//  SearchResultCardView.swift
//  WeatherTracker
//
//  Created by Chufeng Huang on 1/29/25.
//

import SwiftUI

struct SearchResultCardView: View {
    let cityName: String
    let temperature: String
    let iconUrl: String
    var body: some View {
        ZStack{
            Rectangle()
                .foregroundStyle(Color("card_background"))
                .frame(height: 120)
                .cornerRadius(16)
            HStack{
                VStack(alignment: .leading){
                    Text(cityName)
                        .font(.custom("Poppins", size: 20))
                        .foregroundStyle(Color("text_black"))
                    HStack{
                        Text(temperature)
                            .font(.custom("Poppins-Medium", size: 60))
                        VStack{
                            Image(systemName: "circle")
                                .resizable()
                                .frame(width: 6,height: 6)
                            Spacer()
                        }
                    }.frame(height: 50)
                }
                Spacer()
                // Top weather icon
                AsyncImage(url: URL(string: iconUrl)) { phase in
                    switch phase {
                    case .empty:
                        // Loading placeholder
                        ProgressView()
                            .frame(width: 80, height: 80)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(height:80)
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
            }
            .padding(20)
        }
    }
}

#Preview {
    SearchResultCardView(cityName: "Mumbai", temperature: "20", iconUrl: "https://cdn.weatherapi.com/weather/64x64/day/116.png")
}
