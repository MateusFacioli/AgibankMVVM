//
//  MainViewController.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 12/01/26.
//

import Foundation
import SwiftUI

struct MainViewController: View {
    @StateObject private var coordinator = MainCoordinator()
    
    var body: some View {
        NavigationStack(path: $coordinator.nav) {
            coordinator.rootView
                .navigationDestination(for: Route.self) { route in
                    coordinator.view(for: route)
                }
        }
        .environmentObject(coordinator)
    }
}
