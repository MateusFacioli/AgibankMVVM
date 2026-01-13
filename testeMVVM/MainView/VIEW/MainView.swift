//
//  MainView.swift
//  testeMVVM
//
//  Created by Maurício Fonseca on 13/01/26.
//

import SwiftUI
import Foundation

struct MainView: View{
    
    @EnvironmentObject private var coordinator: MainCoordinator
        
        var body: some View {
            VStack(spacing: 16){
                HomeButton(title: "Novo Galpão", icon: "building.2.fill"){
                    coordinator.navigate(to: .create)
                }
                
                HomeButton(title: "Buscar Galpões", icon: "magnifyingglass"){
                    coordinator.navigate(to: .consult)
                }
                
                
            }
            .padding()
            .background(.white)
            .cornerRadius(20)
            .shadow(radius: 10)
            .padding(.horizontal)
            .navigationTitle("MENU")
        }
    }

struct HomeButton: View{
    let title: String
    let icon: String
    let action:() -> Void
    
    var body: some View{
        Button{
            action()
        }label:{
            HStack(spacing: 12){
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(.blue)
                Text(title)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
        
    }
}


#Preview {
    MainView()
}
