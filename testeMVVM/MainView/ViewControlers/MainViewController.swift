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
    @StateObject private var mapsCoordinator = MapsCoordinator()
    
    var body: some View {
        NavigationStack(path: $coordinator.nav) {
            MapsViewController {
                coordinator.rootView
                    .navigationDestination(for: Route.self) { route in
                        coordinator.view(for: route)
                    }
            }
        }
        .environmentObject(coordinator)// injetando
        .environmentObject(mapsCoordinator)
    }
}
