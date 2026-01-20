//
//  LogsView.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 20/01/26.
//


import SwiftUI
import UniformTypeIdentifiers

struct LogsView: View {
    @ObservedObject var viewModel: CicloDeVidaViewModel
    @State private var filtroView: String = ""
    @State private var filtroCor: Log.LogCor?
    @State private var mostrarShareSheet = false
    @State private var logsExportados = ""
    
    var logsFiltrados: [Log] {
        var logs = viewModel.logs
        
        if !filtroView.isEmpty {
            logs = logs.filter { $0.view.localizedCaseInsensitiveContains(filtroView) }
        }
        
        if let filtroCor = filtroCor {
            logs = logs.filter { $0.cor == filtroCor }
        }
        
        return logs
    }
    
    var viewsDisponiveis: [String] {
        Array(Set(viewModel.logs.map { $0.view })).sorted()
    }
    
    var coresDisponiveis: [Log.LogCor] {
        Array(Set(viewModel.logs.map { $0.cor })).sorted { $0.rawValue < $1.rawValue }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // MARK: - Filtros
                VStack(spacing: 10) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.secondary)
                        
                        TextField("Filtrar por view...", text: $filtroView)
                            .textFieldStyle(.plain)
                        
                        if !filtroView.isEmpty {
                            Button {
                                filtroView = ""
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(viewsDisponiveis, id: \.self) { view in
                                Button(view) {
                                    filtroView = view
                                }
                                .font(.caption)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(filtroView == view ? Color.blue : Color(.systemGray5))
                                .foregroundColor(filtroView == view ? .white : .primary)
                                .cornerRadius(15)
                            }
                            
                            ForEach(coresDisponiveis, id: \.self) { cor in
                                Button {
                                    filtroCor = filtroCor == cor ? nil : cor
                                } label: {
                                    HStack(spacing: 4) {
                                        Circle()
                                            .fill(corColor(cor))
                                            .frame(width: 8, height: 8)
                                        
                                        Text(cor.rawValue.capitalized)
                                            .font(.caption)
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(filtroCor == cor ? corColor(cor).opacity(0.3) : Color(.systemGray5))
                                    .foregroundColor(.primary)
                                    .cornerRadius(15)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical, 10)
                .background(Color(.systemBackground))
                
                Divider()
                
                // MARK: - Lista de Logs
                if logsFiltrados.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "terminal")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        
                        Text(filtroView.isEmpty ? "Nenhum log registrado" : "Nenhum log encontrado")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        if !filtroView.isEmpty {
                            Button("Limpar Filtros") {
                                filtroView = ""
                                filtroCor = nil
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                    .frame(maxHeight: .infinity)
                } else {
                    ScrollViewReader { proxy in
                        List {
                            ForEach(logsFiltrados) { log in
                                LogItemView(log: log)
                                    .id(log.id)
                            }
                        }
                        .listStyle(.plain)
                        .onChange(of: logsFiltrados.count) { _, _ in
                            if let primeiro = logsFiltrados.first {
                                withAnimation {
                                    proxy.scrollTo(primeiro.id, anchor: .top)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Logs do Sistema")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        logsExportados = viewModel.exportarLogs()
                        mostrarShareSheet = true
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                    
                    Button {
                        viewModel.resetarContadores()
                    } label: {
                        Image(systemName: "trash")
                    }
                }
            }
            .sheet(isPresented: $mostrarShareSheet) {
                ShareSheet(activityItems: [logsExportados])
            }
        }
        .onAppear {
            print("🟢 LogsView onAppear()")
            viewModel.viewApareceu(nomeView: "LogsView")
        }
        .onDisappear {
            print("🔴 LogsView onDisappear()")
            viewModel.viewDesapareceu(nomeView: "LogsView")
        }
    }
    
    private func corColor(_ cor: Log.LogCor) -> Color {
        switch cor {
        case .info: return .blue
        case .warning: return .orange
        case .error: return .red
        case .success: return .green
        }
    }
}

struct LogItemView: View {
    let log: Log
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Ícone colorido
            Image(systemName: log.icone)
                .font(.caption)
                .foregroundColor(corSwiftUI(log.cor))
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(log.evento)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Text(log.timestampFormatado)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .monospacedDigit()
                }
                
                Text(log.descricao)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                HStack {
                    Text(log.view)
                        .font(.caption2)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(corSwiftUI(log.cor).opacity(0.2))
                        .foregroundColor(corSwiftUI(log.cor))
                        .cornerRadius(4)
                    
                    Spacer()
                }
            }
        }
        .padding(.vertical, 4)
    }
    
    private func corSwiftUI(_ cor: Log.LogCor) -> Color {
        switch cor {
        case .info: return .blue
        case .warning: return .orange
        case .error: return .red
        case .success: return .green
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}