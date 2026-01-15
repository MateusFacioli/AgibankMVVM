//
//  ContentView.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 08/01/26.
//

import SwiftUI

struct ContentView: View {
    @State private var isActive = false
    
    var body: some View {
        ZStack {
            if isActive {
                WeatherMiniApp()
            } else {
                SplashScreenView()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    isActive = true
                }
            }
        }
    }
}

struct SplashScreenView: View {
    var body: some View {
        ZStack {
            Color.blue
                .ignoresSafeArea()
            
            VStack {
                Image(systemName: "star.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.white)
                
                Text("SplashScreen")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 20)
            }
        }
    }
}

#Preview {
    ContentView()
}
