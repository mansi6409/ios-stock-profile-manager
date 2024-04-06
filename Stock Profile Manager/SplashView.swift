//
//  SplashView.swift
//  Stock Profile Manager
//
//  Created by Mansi Garg on 4/5/24.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color(hue: 1.0, saturation: 0.012, brightness: 0.917))
                .edgesIgnoringSafeArea(.all)
            Image("app_icon")
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
        }
    }
}

#Preview {
    SplashView()
}
