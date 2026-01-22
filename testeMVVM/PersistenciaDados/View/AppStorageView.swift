//
//  AppStorageView.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 22/01/26.
//


import SwiftUI

struct AppStorageView: View {
    @ObservedObject var viewModel: PersistenciaViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Título
                VStack {
                    Image(systemName: "app.badge.fill")
                        .font(.title)
                        .foregroundColor(.purple)
                    Text("AppStorage")
                        .font(.title2)
                        .bold()
                }
                .padding(.top)
                
                // Controles
                VStack(spacing: 15) {
                    TextField("Nome", text: $viewModel.nomeAppStorage)
                        .textFieldStyle(.roundedBorder)
                    
                    HStack {
                        Text("Contador: \(viewModel.contadorAppStorage)")
                        Spacer()
                        Button {
                            viewModel.aumentarContadorAppStorage()
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                        }
                    }
                    
                    Toggle("Ativo", isOn: $viewModel.toggleAppStorage)
                    
                    Button("Limpar") {
                        viewModel.limparAppStorage()
                    }
                    .buttonStyle(.bordered)
                    .tint(.red)
                }
                .padding(.horizontal)
                
                // Status
                VStack(alignment: .leading, spacing: 10) {
                    Text("Status:")
                        .font(.headline)
                    
                    HStack {
                        Text("Nome:")
                        Spacer()
                        Text(viewModel.nomeAppStorage.isEmpty ? "Vazio" : "Salvo")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Contador:")
                        Spacer()
                        Text("\(viewModel.contadorAppStorage)")
                            .bold()
                    }
                    
                    HStack {
                        Text("Toggle:")
                        Spacer()
                        Text(viewModel.toggleAppStorage ? "Ligado" : "Desligado")
                            .foregroundColor(viewModel.toggleAppStorage ? .green : .red)
                    }
                }
                .padding()
                .background(Color.purple.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal)
            }
        }
    }
}
