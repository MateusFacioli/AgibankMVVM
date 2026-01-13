//
//  AllStockView.swift
//  testeMVVM
//
//  Created by Maurício Fonseca on 12/01/26.
//

import SwiftUI

struct AllStockView: View {
    
    @ObservedObject var viewModel: StockViewModel
    
    @EnvironmentObject private var coordinator: MainCoordinator

    
    var body: some View {
        
        List{
            
            Section{
                TextField("Buscar por ID do Galpão", text: $viewModel.searchId)
                    .keyboardType(.numberPad)
            }
            
            if viewModel.searchId.isEmpty {
                ForEach(viewModel.galpoes.indices, id: \.self){index in
                    let galpao = viewModel.galpoes[index]
                    
                    Section(header: Text("Galpão #\(galpao.idGalpao)")){
                        galpaoInfo(galpao)
                            Button{
                                coordinator.navigate(to: .update)
                            }label:{
                                Text("Editar Galpão")
                                    .foregroundColor(.blue)
                            }
                            Button{
                                viewModel.removerGalpao(idGalpao: galpao.idGalpao)
                            }label:{
                                Text("Excluir Galpão")
                                    .foregroundColor(.red)
                            }
                    }
                }
            } else{
                if let galpao = viewModel.buscarPorId(){
                    Section(header: Text("Galpão #\(galpao.idGalpao)")){
                        galpaoInfo(galpao)
                        Button{
                            coordinator.navigate(to: .update)
                        }label:{
                            Text("Editar Galpão")
                                .foregroundColor(.blue)
                        }
                        Button{
                            viewModel.removerGalpao(idGalpao: galpao.idGalpao)
                        }label:{
                            Text("Excluir Galpão")
                                .foregroundColor(.red)
                        }
                    }
                } else {
                    Text("Nenhum galpão encontrado para esse ID")
                }
            }
        }
        .navigationTitle("Todos Galpões")
    }
    
    @ViewBuilder
    private func galpaoInfo(_ galpao: StockModel) -> some View{
        VStack(alignment: .leading, spacing: 8){
            Text("Local: \(galpao.localGalpao)")
            Text("Andar: \(galpao.andar)")
            Text("Setor: \(galpao.setor)")
            Text("Prateleira: \(galpao.prateleira)")
            Text("Departamento: \(galpao.departamento)")
        }
        .padding(.vertical, 4)
    }
}


#Preview {
    var viewModel = StockViewModel()
    AllStockView(viewModel: viewModel)
}
