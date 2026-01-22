//
//  PersistenciaView.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 22/01/26.
//

import SwiftUI

struct PersistenciaView: View {
    @StateObject private var viewModel = PersistenciaViewModel()
    @State private var abaSelecionada = 0
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Cabeçalho
                VStack(spacing: 10) {
                    Image(systemName: "externaldrive.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.blue)
                    
                    Text("Persistência de Dados")
                        .font(.title)
                        .bold()
                    
                    Text("SwiftUI + MVVM")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.top)
                
                // Status
                if !viewModel.mensagemStatus.isEmpty {
                    Text(viewModel.mensagemStatus)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                
                // Abas
                TabView(selection: $abaSelecionada) {
                    UserDefaultsView(viewModel: viewModel)
                        .tag(0)
                    
                    AppStorageView(viewModel: viewModel)
                        .tag(1)
                    
                    JSONFileView(viewModel: viewModel)
                        .tag(2)
                    
                    ComparacaoView(viewModel: viewModel)
                        .tag(3)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(height: 450)
                
                // Navegação
                HStack {
                    ForEach(0..<4, id: \.self) { index in
                        Button(action: { abaSelecionada = index }) {
                            VStack {
                                Image(systemName: iconeAba(index))
                                    .font(.caption)
                                Text(tituloAba(index))
                                    .font(.caption2)
                            }
                            .padding(8)
                            .background(abaSelecionada == index ? Color.blue : Color.clear)
                            .foregroundColor(abaSelecionada == index ? .white : .primary)
                            .cornerRadius(8)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.bottom)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        compartilharDados()
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
        }
    }
    
    private func iconeAba(_ index: Int) -> String {
        switch index {
        case 0: return "archivebox"
        case 1: return "app.badge"
        case 2: return "doc.text"
        case 3: return "chart.bar"
        default: return ""
        }
    }
    
    private func tituloAba(_ index: Int) -> String {
        switch index {
        case 0: return "Defaults"
        case 1: return "Storage"
        case 2: return "JSON"
        case 3: return "Comparar"
        default: return ""
        }
    }
    
    private func compartilharDados() {
        let dados = viewModel.exportarDados()
        print("📋 Dados para compartilhar:\n\(dados)")
        
        // Mostrar alerta com os dados
        let alerta = UIAlertController(
            title: "Dados Exportados",
            message: dados,
            preferredStyle: .alert
        )
        
        alerta.addAction(UIAlertAction(title: "Copiar", style: .default) { _ in
            UIPasteboard.general.string = dados
            viewModel.mensagemStatus = "📋 Dados copiados!"
        })
        
        alerta.addAction(UIAlertAction(title: "OK", style: .cancel))
        
        // Mostrar alerta
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(alerta, animated: true)
        }
    }
}

#Preview {
    PersistenciaView()
}
