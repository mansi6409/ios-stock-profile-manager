//
//  Stock_Profile_ManagerApp.swift
//  Stock Profile Manager
//
//  Created by Mansi Garg on 4/3/24.
//

import SwiftUI

@main
struct Stock_Profile_ManagerApp: App {
    @State private var showSplashScreen = true

    var body: some Scene {
        WindowGroup {
            if showSplashScreen {
                SplashView()
                    .onAppear{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 4)
                        {
                            showSplashScreen = false
                        }
                    }
            } else {
                ContentView()
            }
        }
    }
}
