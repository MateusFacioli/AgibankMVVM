//
//  MapsMiniApp.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 15/01/26.
//


import SwiftUI

/// Mini aplicativo de Mapas (starter) isolado do restante do projeto
/// Estrutura MVVM: MapsView <-> MapsViewModel
struct MapsMiniApp: View {
    @StateObject private var viewModel = MapsViewModel()

    var body: some View {
        NavigationStack {
            LocationView()
            //MapsView(viewModel: viewModel)
                .navigationTitle("Mapas")
        }
    }
}

#Preview {
    MapsMiniApp()
}
