//
//  ComparacaoView.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 22/01/26.
//


import SwiftUI

struct ComparacaoView: View {
    @ObservedObject var viewModel: PersistenciaViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Título
                VStack {
                    Image(systemName: "chart.bar.doc.horizontal")
                        .font(.title)
                        .foregroundColor(.blue)
                    Text("Comparação")
                        .font(.title2)
                        .bold()
                }
                .padding(.top)
                
                // Métodos
                VStack(spacing: 15) {
                    metodoCard(
                        titulo: "UserDefaults",
                        cor: .orange,
                        uso: "Dados simples",
                        vantagens: ["Simples", "Nativo"],
                        desvantagens: ["Não seguro", "Limitado"]
                    )
                    
                    metodoCard(
                        titulo: "AppStorage",
                        cor: .purple,
                        uso: "Configurações UI",
                        vantagens: ["SwiftUI nativo", "Reativo"],
                        desvantagens: ["SwiftUI only", "Mesmas limitações"]
                    )
                    
                    metodoCard(
                        titulo: "JSON File",
                        cor: .green,
                        uso: "Dados estruturados",
                        vantagens: ["Estrutura complexa", "Portátil"],
                        desvantagens: ["Mais complexo", "Performance"]
                    )
                }
                .padding(.horizontal)
                
                // Dicas
                VStack(alignment: .leading, spacing: 10) {
                    Text("💡 Dicas:")
                        .font(.headline)
                    
                    Text("• UserDefaults: Use para configurações simples")
                    Text("• AppStorage: Use em SwiftUI para preferências")
                    Text("• JSON: Use para dados estruturados complexos")
                    Text("• CoreData: Use para grandes volumes de dados")
                }
                .font(.caption)
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal)
            }
        }
    }
    
    func metodoCard(titulo: String, cor: Color, uso: String, vantagens: [String], desvantagens: [String]) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(titulo)
                    .font(.headline)
                    .foregroundColor(cor)
                Spacer()
                Text(uso)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .background(cor.opacity(0.2))
                    .cornerRadius(5)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("✅")
                    .font(.caption)
                ForEach(vantagens, id: \.self) {
                    Text("• \($0)")
                        .font(.caption2)
                }
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("❌")
                    .font(.caption)
                ForEach(desvantagens, id: \.self) {
                    Text("• \($0)")
                        .font(.caption2)
                }
            }
        }
        .padding()
        .background(cor.opacity(0.1))
        .cornerRadius(10)
    }
}
