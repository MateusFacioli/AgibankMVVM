//
//  STOCKVIEW.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 08/01/26.
//

import SwiftUI
import MapKit
///Esta é a tela (View) principal que mostra o formulário e um botão para consultar os dados.

struct STOCKVIEW: View {
/// @StateObject: esta View é DONA do ViewModel. Isso significa que a instância é criada uma única vez e preservada, enquanto a view existir, mesmo que o body seja recalculado várias vezes. Use @StateObject quando a própria view cria e gerencia o ciclo de vida do objeto observável, consultando alterações
    /// Se criassemos o ViewModel sem @StateObject (por exemplo, como var ou com @ObservedObject inicializando ali), uma nova instância seria criada a cada build. Isso faria perdemos o estado (o que o user digitou)
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject private var mapsCoordinator: MapsCoordinator
    @StateObject var viewModel: StockViewModel = StockViewModel(
        stock: STOCKMODEL(
        /// esse  são valores iniciais  default na UI .
            prateleira: 1234,
            local_galpao: LocationCoordinateModel(latitude: -40, longitude: -37),
            andar: 4,
            setor: 56,
            depto: "diversos",
            id_item: "45678900",
            id_galpao: 4500
        )
    )
    
    var body: some View {
        ZStack{
            Color(colorScheme == .dark ? .black : .white)
                .ignoresSafeArea()
            
            ///Como o FormTextFieldView usa @ObservedObject, ele observa este viewModel e atualiza a UI quando qualquer campo do 'stock' muda. Os TextFields dentro do formulário estão ligados (Binding) às propriedades do ViewModel.
            
            FormTextFieldView(alteracaoobj: viewModel)
        }
        
        Image("Sap")

        if let coord = viewModel.stock.local_galpao {
            Text("Localização escolhida: \(.init(format: "%.5f", coord.latitude)), \(.init(format: "%.5f", coord.longitude))")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        Divider().padding(.vertical, 8)
        
        VStack {
            VStack(spacing: 8) {
                Button("Consultar galpões") {
                    print("DADOS DO STOCK \(viewModel.stock)")
                }
                Button("Definir localização (Callback)") { mapsCoordinator.presentCallback() }
                Button("Definir localização (Shared ViewModel)") { mapsCoordinator.presentSharedVM() }
                Button("Definir localização (Binding)") { mapsCoordinator.presentBinding() }
            }
            Divider().padding(.vertical, 8)
            
        }
        .onChange(of: mapsCoordinator.pickedCoordinate) { _, newValue in
            if let coord = newValue {
                viewModel.stock.local_galpao = coord
            }
        }
    }
}

#Preview {
    STOCKVIEW()
        .environmentObject(MapsCoordinator())
}
