//
//  UserDefaultsView.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 22/01/26.
//


import SwiftUI

struct UserDefaultsView: View {
    @ObservedObject var viewModel: PersistenciaViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Título
                VStack {
                    Image(systemName: "archivebox.fill")
                        .font(.title)
                        .foregroundColor(.orange)
                    Text("UserDefaults")
                        .font(.title2)
                        .bold()
                }
                .padding(.top)
                
                // Formulário
                VStack(spacing: 15) {
                    TextField("Nome", text: $viewModel.nomeUserDefaults)
                        .textFieldStyle(.roundedBorder)
                    
                    Stepper("Contador: \(viewModel.contadorUserDefaults)",
                           value: $viewModel.contadorUserDefaults)
                    
                    HStack(spacing: 10) {
                        Button("Salvar") {
                            viewModel.salvarComUserDefaults()
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.orange)
                        .disabled(viewModel.nomeUserDefaults.isEmpty)
                        
                        Button("Carregar") {
                            viewModel.carregarUserDefaults()
                        }
                        .buttonStyle(.bordered)
                        
                        Button("Limpar") {
                            viewModel.limparUserDefaults()
                        }
                        .buttonStyle(.bordered)
                        .tint(.red)
                    }
                }
                .padding(.horizontal)
                
                // Status
                VStack(alignment: .leading, spacing: 10) {
                    Text("Status:")
                        .font(.headline)
                    
                    Text(viewModel.userDefaultsTemDados() ? "✅ Dados salvos" : "📭 Nenhum dado")
                        .foregroundColor(viewModel.userDefaultsTemDados() ? .green : .gray)
                    
                    if viewModel.userDefaultsTemDados() {
                        Text("Nome: \(viewModel.nomeUserDefaults)")
                        Text("Contador: \(viewModel.contadorUserDefaults)")
                    }
                }
                .padding()
                .background(Color.orange.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal)
            }
        }
    }
}
