import SwiftUI

/// Seletor de Mini Projetos
/// Use esta view como entrada para acessar módulos isolados do app
struct RootSelectorView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Mini Apps") {
                    NavigationLink("API de Clima (HG Brasil)") { WeatherMiniApp() }
                    NavigationLink("Mapas (starter)") { MapsMiniApp() }
                }
                Section("Arquitetura") {
                    NavigationLink("Arquitetura (Fluxo Principal)") { ArquiteturaView() }
                }
            }
            .navigationTitle("Projetos")
        }
    }
}

#Preview { RootSelectorView() }
