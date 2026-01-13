//
//  MainCoodinator.swift
//  testeMVVM
//
//  Created by Maurício Fonseca on 13/01/26.
//

import Foundation
import SwiftUI
import Combine

// Aqui estamos criando uma classe especializada na coordenação de troca de telas, nessa em específico vai cuidar do menu em diante.
final class MainCoordinator: ObservableObject {
    
    let viewModel = StockViewModel()
    // Tornamos essa variavel possivel de ser alterada/observada em outras classes e structs, é um objeto da classe NaviagionPath, que vai armazenar o caminho de navegação.
    @Published var nav = NavigationPath()
    
    // Variavel responsável por retonar a view principal dela.
    var rootView: some View {
        MainView()
            .environmentObject(self)
    }
    
    // Função responsável pela navegação e agregar ao caminho cada tela que fomos para conseguir criar
    func navigate(to route: Route){
        nav.append(route)
    }
    
    // Função que vai ser utilizada para voltar uma tela
    func pop(){
        if !nav.isEmpty {
            nav.removeLast()
        }
    }

    // Nessa função vamos zerar a variavel nav, ou seja, vamos voltar direto para o padrão que vai ser nossa root view.
    func popToRoot(){
        nav = NavigationPath()
    }
    @ViewBuilder
    func view(for route: Route) -> some View{
        switch route {
        case .create:
            StockView(viewModel: self.viewModel)
        case .remove:
            MainView()
        case .update:
            MainView()
        case . consult:
            AllStockView(viewModel: self.viewModel)
        case .location:
            MainView()
        }
    }
}
