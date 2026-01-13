//
//  STOCKVIEW.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 08/01/26.
//

import SwiftUI
///Esta é a tela (View) principal que mostra o formulário e um botão para consultar os dados.

struct StockView: View {

    @ObservedObject var viewModel: StockViewModel
    @StateObject private var mapsCoordinator = MapsCoordinator()

    var body: some View {
        MapsViewController {
            VStack {
                FormTextFieldView(
                    viewModel: viewModel,
                    onSelectLocation: {
                        mapsCoordinator.presentCallback()
                    }
                )

                Button("Cadastrar Galpão") {
                    viewModel.cadastrarGalpao()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .environmentObject(mapsCoordinator)
        .onChange(of: mapsCoordinator.pickedCoordinate) { _, newValue in
            if let coord = newValue {
                viewModel.setLocation(
                    coord,
                    displayName: "Local selecionado"
                )
            }
        }
    }
}

#Preview {
    var viewModel = StockViewModel()
    StockView(viewModel: viewModel)
}
