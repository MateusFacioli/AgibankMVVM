//
//  MainCoordinator.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 12/01/26.
//

import Foundation
import SwiftUI
import Combine

final class MainCoordinator: ObservableObject {
    @Published var nav = NavigationPath()
    
    var rootView: some View {
        ExampleView()
            .environmentObject(self)
    }
    
    func navigate(to route: Route) {
        nav.append(route)
    }
    
    func pop() {
        if !nav.isEmpty {
            nav.removeLast()
        }
    }
   
    func popToRoot() {
        nav = NavigationPath()
    }
    
    @ViewBuilder
    func view(for route: Route) -> some View {
        switch route {
        case .create:
            STOCKVIEW() // tarefa
        case .remove:
            ExampleView() // tarefa
        case .update:
            ExampleView() // tarefa
        case .consult:
            ExampleView() // tarefa
        case .location:
            ExampleView() // tarefa
        }
    }
}


struct ExampleView: View {
    @EnvironmentObject private var coordinator: MainCoordinator
    
    var body: some View {
        List {
            Section("Dashboard") {
                Button("Ir para criar") {
                    coordinator.navigate(to: .create)
                }
                Button("Ir para remover") {
                    coordinator.navigate(to: .remove)
                }
                Button("Ir para atualizar") {
                    coordinator.navigate(to: .update)
                }
                Button("Ir para consultar") {
                    coordinator.navigate(to: .consult)
                }
            }
        }
        .navigationTitle("MENU")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Root") { coordinator.popToRoot() }
            }
        }
    }
}

#Preview {
    ExampleView()
}
