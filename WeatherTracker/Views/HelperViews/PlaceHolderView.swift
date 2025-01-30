//
//  PlaceHolderView.swift
//  WeatherTracker
//
//  Created by Chufeng Huang on 1/29/25.
//

import SwiftUI

struct PlaceHolderView: View {
    var body: some View {
        VStack(spacing: 20){
            Text("No City Selected")
                .font(.custom("Poppins-Bold", size: 30))
                .foregroundColor(Color("text_black"))
                .frame(height: 50)
            
            Text("Please Search For A City")
                .font(.custom("Poppins", size: 15))
                .foregroundColor(Color("text_black"))
        }
    }
}

#Preview {
    PlaceHolderView()
}
