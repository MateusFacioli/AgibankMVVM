//
//  DetalhesCicloView.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 20/01/26.
//


import SwiftUI

struct DetalhesCicloView: View {
    @ObservedObject var viewModel: CicloDeVidaViewModel
    @State private var etapaExpandida: UUID?
    @State private var filtroMomento: EtapaCiclo.MomentoCiclo? = nil
    
    //factory
    var etapasFiltradas: [EtapaCiclo] {
        if let filtro = filtroMomento {
            return DadosCiclo.etapas.filter { $0.momento == filtro }
        }
        return DadosCiclo.etapas
    }
    
    var momentos: [EtapaCiclo.MomentoCiclo] {
        Array(Set(DadosCiclo.etapas.map { $0.momento })).sorted { $0.rawValue < $1.rawValue }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // MARK: - Filtros
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            Button("Todos") {
                                filtroMomento = nil
                            }
                            .buttonStyle(.bordered)
                            .tint(filtroMomento == nil ? .blue : .gray)
                            
                            ForEach(momentos, id: \.self) { momento in
                                Button(momento.rawValue) {
                                    filtroMomento = momento
                                }
                                .buttonStyle(.bordered)
                                .tint(filtroMomento == momento ? momentoCor(momento) : .gray)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top)
                    
                    // MARK: - Lista de Etapas
                    LazyVStack(spacing: 12) {
                        ForEach(etapasFiltradas) { etapa in
                            EtapaCardView(
                                etapa: etapa,
                                isExpanded: etapaExpandida == etapa.id
                            )
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    if etapaExpandida == etapa.id {
                                        etapaExpandida = nil
                                    } else {
                                        etapaExpandida = etapa.id
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // MARK: - Comparação UIKit vs SwiftUI
                    VStack(alignment: .leading, spacing: 15) {
                        Text("📱 UIKit vs SwiftUI")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ComparisonRow(
                            titulo: "Inicialização",
                            uikit: "viewDidLoad()",
                            swiftui: "init() + body computed",
                            cor: .blue
                        )
                        
                        ComparisonRow(
                            titulo: "Aparecimento",
                            uikit: "viewWillAppear + viewDidAppear",
                            swiftui: "onAppear + task",
                            cor: .green
                        )
                        
                        ComparisonRow(
                            titulo: "Desaparecimento",
                            uikit: "viewWillDisappear + viewDidDisappear",
                            swiftui: "onDisappear",
                            cor: .red
                        )
                        
                        ComparisonRow(
                            titulo: "Observação",
                            uikit: "Delegates/KVO",
                            swiftui: "@Published + onChange",
                            cor: .orange
                        )
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .shadow(color: .black.opacity(0.05), radius: 5)
                }
                .padding(.bottom)
            }
            .navigationTitle("Etapas do Ciclo")
            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear {
            print("🟢 DetalhesCicloView onAppear()")
            viewModel.viewApareceu(nomeView: "DetalhesCicloView")
        }
        .onDisappear {
            print("🔴 DetalhesCicloView onDisappear()")
            viewModel.viewDesapareceu(nomeView: "DetalhesCicloView")
        }
    }
    
    private func momentoCor(_ momento: EtapaCiclo.MomentoCiclo) -> Color {
        switch momento {
        case .inicializacao: return .blue
        case .aparecimento: return .green
        case .desaparecimento: return .red
        case .destruicao: return .purple
        case .background: return .orange
        }
    }
}

struct ComparisonRow: View {
    let titulo: String
    let uikit: String
    let swiftui: String
    let cor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(titulo)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(cor)
            
            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("UIKit")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(uikit)
                        .font(.caption)
                        .fontWeight(.medium)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Image(systemName: "arrow.left.arrow.right")
                    .foregroundColor(.gray)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("SwiftUI")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(swiftui)
                        .font(.caption)
                        .fontWeight(.medium)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding()
        .background(cor.opacity(0.1))
        .cornerRadius(8)
    }
}
