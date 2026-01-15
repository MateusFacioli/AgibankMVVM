import SwiftUI

/// Visão de Arquitetura (renomeada de MainView)
/// Mantém o fluxo principal com o MainCoordinator
struct ArquiteturaView: View {
    @StateObject private var coordinator = MainCoordinator()
    @StateObject private var mapsCoordinator = MapsCoordinator()

    var body: some View {
        NavigationStack(path: $coordinator.nav) {
            coordinator.rootView
                .navigationDestination(for: Route.self) { route in
                    coordinator.view(for: route)
                }
        }
        .environmentObject(coordinator)
        .environmentObject(mapsCoordinator)
        .navigationTitle("Arquitetura")
    }
}

#Preview { ArquiteturaView() }
