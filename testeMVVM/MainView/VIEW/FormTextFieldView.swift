//
//  FormTextFieldView.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 08/01/26.
//

import SwiftUI

///Esta view mostra um formulário que edita os dados de um estoque. Ela não guarda os dados por conta própria. Em vez disso, recebe um ViewModel que é observado por mudanças.
struct FormTextFieldView: View {
    ///@ObservedObject: A view "escuta" mudanças publicadas pelo ViewModel. Quando o ViewModel muda (por exemplo, quando alguma propriedade @Published muda), a UI é atualizada automaticamente.
    @ObservedObject var viewModel: StockViewModel
    
    let onSelectLocation: (() -> Void)?
    
    var body: some View {
        Form {
            Section ("Cadastro de Galpão"){
                TextField(
                    "ID do galpão",
                    text: $viewModel.idGalpao
                )
                .keyboardType(.numberPad)

                Button {
                    onSelectLocation?()
                } label: {
                    HStack {
                        Text(
                            viewModel.localGalpao.isEmpty
                            ? "Selecionar localização no mapa"
                            : viewModel.localGalpao
                        )
                        .foregroundColor(
                            viewModel.localGalpao.isEmpty ? .secondary : .primary
                        )

                        Spacer()
                        Image(systemName: "map")
                    }
                }
                .keyboardType(.default)

                TextField(
                    "Andar",
                    text: $viewModel.andar
                )
                .keyboardType(.numberPad)

                TextField(
                    "Departamento",
                    text: $viewModel.departamento
                )

                TextField(
                    "Prateleira",
                    text: $viewModel.prateleira
                )
                .keyboardType(.numberPad)

                TextField(
                    "Setor",
                    text: $viewModel.setor
                )
                .keyboardType(.numberPad)
            }
        }
    }
}
#Preview {
    var mapsCoordinator = MapsCoordinator()
    var viewModelPrev = StockViewModel()
    FormTextFieldView(viewModel: viewModelPrev, onSelectLocation: {
        mapsCoordinator.presentCallback()
    })
}
