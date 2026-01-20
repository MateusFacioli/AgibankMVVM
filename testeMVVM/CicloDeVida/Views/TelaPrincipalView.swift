//
//  TelaPrincipalView.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 20/01/26.
//


import SwiftUI

struct TelaPrincipalView: View {
    @ObservedObject var viewModel: CicloDeVidaViewModel
    @State private var contadorLocal = 0
    @State private var textoInput = ""
    @State private var mostrarAlerta = false
    @State private var rotation: Double = 0
    
    // Equivalente a propriedades computadas do UIKit
    var statusVisibilidade: String {
        viewModel.estaVisivel ? "VISÍVEL ✅" : "OCULTA ❌"
    }
    
    var statusFaseApp: String {
        switch viewModel.faseApp {
        case .active: return "ATIVO 📱"
        case .inactive: return "INATIVO ⏸️"
        case .background: return "BACKGROUND 📴"
        @unknown default: return "DESCONHECIDO ❓"
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // MARK: - Header
                    VStack(spacing: 10) {
                        Image(systemName: "arrow.clockwise.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.blue)
                            .rotationEffect(.degrees(rotation))
                            .onAppear {
                                withAnimation(.linear(duration: 10).repeatForever(autoreverses: false)) {
                                    rotation = 360
                                }
                            }
                        
                        Text("Ciclo de Vida SwiftUI")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Demonstração Interativa")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top)
                    
                    // MARK: - Cards de Status
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                        StatusCard(
                            titulo: "Status View",
                            valor: statusVisibilidade,
                            cor: viewModel.estaVisivel ? .green : .red,
                            icone: viewModel.estaVisivel ? "eye.fill" : "eye.slash.fill"
                        )
                        
                        StatusCard(
                            titulo: "Fase App",
                            valor: statusFaseApp,
                            cor: .blue,
                            icone: "app.badge.fill"
                        )
                        
                        StatusCard(
                            titulo: "Aparições",
                            valor: "\(viewModel.contadorAparicoes)",
                            cor: .green,
                            icone: "arrow.up.circle.fill"
                        )
                        
                        StatusCard(
                            titulo: "Desaparições",
                            valor: "\(viewModel.contadorDesaparicoes)",
                            cor: .orange,
                            icone: "arrow.down.circle.fill"
                        )
                        
                        StatusCard(
                            titulo: "Tempo Visível",
                            valor: "\(Int(viewModel.tempoVisivel))s",
                            cor: .purple,
                            icone: "timer"
                        )
                        
                        StatusCard(
                            titulo: "Logs",
                            valor: "\(viewModel.logs.count)",
                            cor: .indigo,
                            icone: "terminal.fill"
                        )
                    }
                    .padding(.horizontal)
                    
                    // MARK: - Controles Interativos
                    VStack(spacing: 15) {
                        Text("Controles Interativos")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                        
                        HStack(spacing: 10) {
                            Button {
                                contadorLocal += 1
                                print("🔘 Botão pressionado: contador = \(contadorLocal)")
                                viewModel.propriedadeMudou(nome: "contadorLocal",
                                                         valorAntigo: contadorLocal - 1,
                                                         valorNovo: contadorLocal)
                            } label: {
                                Label("Incrementar (\(contadorLocal))", systemImage: "plus.circle.fill")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)
                            
                            Button {
                                viewModel.simularErro()
                                mostrarAlerta = true
                            } label: {
                                Label("Simular Erro", systemImage: "exclamationmark.triangle.fill")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.bordered)
                            .tint(.orange)
                        }
                        .padding(.horizontal)
                        
                        TextField("Digite algo para observar onChange...", text: $textoInput)
                            .textFieldStyle(.roundedBorder)
                            .padding(.horizontal)
                            .onChange(of: textoInput) { valorAntigo, valorNovo in
                                if !valorAntigo.isEmpty || !valorNovo.isEmpty {
                                    viewModel.propriedadeMudou(nome: "textoInput",
                                                             valorAntigo: valorAntigo,
                                                             valorNovo: valorNovo)
                                }
                            }
                    }
                    
                    // MARK: - Explicação
                    VStack(alignment: .leading, spacing: 10) {
                        Text("🎯 Como Funciona:")
                            .font(.headline)
                        
                        Text("1. **onAppear**: Contador incrementa quando view aparece")
                            .font(.caption)
                        
                        Text("2. **onDisappear**: Contador incrementa quando view desaparece")
                            .font(.caption)
                        
                        Text("3. **onChange**: Log registrado quando propriedades mudam")
                            .font(.caption)
                        
                        Text("4. **@Published**: View atualiza automaticamente")
                            .font(.caption)
                    }
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    
                    Spacer(minLength: 20)
                }
            }
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.resetarContadores()
                    } label: {
                        Image(systemName: "arrow.counterclockwise.circle.fill")
                    }
                }
            }
            .alert("Erro Simulado", isPresented: $mostrarAlerta) {
                Button("OK") { }
            } message: {
                Text("Este é um erro simulado para demonstrar o ciclo de tratamento.")
            }
        }
        // MARK: - Ciclo de Vida desta View específica
        .onAppear {
            print("🟢 TelaPrincipalView onAppear()")
            viewModel.viewApareceu(nomeView: "TelaPrincipalView")
        }
        .onDisappear {
            print("🔴 TelaPrincipalView onDisappear()")
            viewModel.viewDesapareceu(nomeView: "TelaPrincipalView")
        }
    }
}

struct StatusCard: View {
    let titulo: String
    let valor: String
    let cor: Color
    let icone: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icone)
                .font(.title2)
                .foregroundColor(cor)
            
            Text(titulo)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(valor)
                .font(.system(.body, design: .monospaced))
                .fontWeight(.semibold)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity, minHeight: 100)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(cor.opacity(0.3), lineWidth: 1)
        )
    }
}