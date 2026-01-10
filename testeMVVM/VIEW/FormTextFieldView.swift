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
    @ObservedObject var alteracaoobj: StockViewModel
    
    var body: some View {
        Form {
            Section {
                ///O "$" cria um Binding para a propriedade publicada no ViewModel. Binding é um "link de duas vias": o que o usuário digita atualiza o modelo, e se o modelo muda, o campo também mostra a mudança.
                TextField(
                    "ID do galpão",
                    value: $alteracaoobj.stock.id_galpao,
                    format: .number
                )
                .keyboardType(.numberPad)

                TextField(
                    "Local do galpão",
                    text: Binding(
                        // get: como ler o valor atual para mostrar no campo.
                        // Se for nil, mostramos "" para evitar crash.
                        get: { alteracaoobj.stock.local_galpao ?? "" },
                        // set: como escrever de volta no modelo quando o usuário digita.
                        set: { alteracaoobj.stock.local_galpao = $0 }
                    )
                )
                .keyboardType(.default)

                TextField(
                    "Andar",
                    value: Binding(
                        // get: se for nil, mostramos 0 como padrão no campo
                        get: { alteracaoobj.stock.andar ?? 0 },
                        // set: quando o usuário digita um número, salvamos no modelo
                        set: { alteracaoobj.stock.andar = $0 }
                    ),
                    format: .number
                )
                .keyboardType(.numberPad)

                TextField(
                    "Departamento",
                    text: Binding(
                        get: { alteracaoobj.stock.depto ?? "" },
                        set: { alteracaoobj.stock.depto = $0 }
                    )
                )
                .textFieldStyle(.roundedBorder)

                TextField(
                    "Prateleira",
                    value: Binding(
                        get: { alteracaoobj.stock.prateleira ?? 0 },
                        set: { alteracaoobj.stock.prateleira = $0 }
                    ),
                    format: .number
                )
                .keyboardType(.numberPad)

                TextField(
                    "Setor",
                    value: Binding(
                        get: { alteracaoobj.stock.setor ?? 0 },
                        set: { alteracaoobj.stock.setor = $0 }
                    ),
                    format: .number
                )
                .keyboardType(.numberPad)

                /// Aqui podemos usar diretamente $alteracaoobj.stock.id_item porque não precisamos converter de/para opcional.
                TextField("ID do item", text: $alteracaoobj.stock.id_item)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.numberPad)
            }
        }
    }
}
///Somente esses 2 campos do modelo não são opcionais logo precisam de implementação
#Preview {
    FormTextFieldView(alteracaoobj: StockViewModel(stock: STOCKMODEL(id_item: "", id_galpao: 1)))
}
