//
//  STOCKVIEW.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 08/01/26.
//

import SwiftUI
///Esta é a tela (View) principal que mostra o formulário e um botão para consultar os dados.

struct STOCKVIEW: View {
/// @StateObject: esta View é DONA do ViewModel. Isso significa que a instância é criada uma única vez e preservada, enquanto a view existir, mesmo que o body seja recalculado várias vezes. Use @StateObject quando a própria view cria e gerencia o ciclo de vida do objeto observável, consultando alterações
    /// Se criassemos o ViewModel sem @StateObject (por exemplo, como var ou com @ObservedObject inicializando ali), uma nova instância seria criada a cada build. Isso faria perdemos o estado (o que o user digitou)
    @StateObject var viewModel: StockViewModel = StockViewModel(
        stock: STOCKMODEL(
        /// esse  são valores iniciais  default na UI .
            prateleira: 1234,
            local_galpao: "americana",
            andar: 4,
            setor: 56,
            depto: "diversos",
            id_item: "45678900",
            id_galpao: 4500
        )
    )
    
    var body: some View {
    
        ///Como o FormTextFieldView usa @ObservedObject, ele observa este viewModel e atualiza a UI quando qualquer campo do 'stock' muda. Os TextFields dentro do formulário estão ligados (Binding) às propriedades do ViewModel.
        
        FormTextFieldView(alteracaoobj: viewModel)
        
        Spacer()
        
        HStack {
            Button("Consultar galpões") {
                print("DADOS DO STOCK \(viewModel.stock)")
            }
        }
    }
}

#Preview {
    STOCKVIEW()
}
