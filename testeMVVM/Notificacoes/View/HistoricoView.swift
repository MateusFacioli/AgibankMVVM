//
//  HistoricoView.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 20/01/26.
//


import SwiftUI

struct HistoricoView: View {
    @ObservedObject var notificacaoVM: NotificacaoViewModel
    @State private var filtroStatus: FiltroStatus = .todas
    @State private var filtroCategoria: Notificacao.CategoriaNotificacao?
    @State private var mostrarDetalhes: Notificacao?
    @State private var modoVisualizacao: ModoVisualizacao = .lista
    
    enum FiltroStatus: String, CaseIterable {
        case todas = "Todas"
        case ativas = "Ativas"
        case entregues = "Entregues"
        case expiradas = "Expiradas"
    }
    
    enum ModoVisualizacao: String, CaseIterable {
        case lista = "Lista"
        case calendario = "Calendário"
    }
    
    var notificacoesFiltradas: [Notificacao] {
        var notificacoes = notificacaoVM.notificacoes
        
        // Filtrar por status
        switch filtroStatus {
        case .ativas:
            notificacoes = notificacoes.filter { $0.estaAtiva }
        case .entregues:
            notificacoes = notificacoes.filter { $0.foiEntregue }
        case .expiradas:
            notificacoes = notificacoes.filter { !$0.estaAtiva && !$0.foiEntregue }
        case .todas:
            break
        }
        
        // Filtrar por categoria (se selecionada)
        if let categoria = filtroCategoria {
            notificacoes = notificacoes.filter { $0.categoria == categoria }
        }
        
        // Ordenar por data (mais recente primeiro)
        return notificacoes.sorted { $0.dataAgendamento > $1.dataAgendamento }
    }
    
    var categoriasDisponiveis: [Notificacao.CategoriaNotificacao] {
        Array(Set(notificacaoVM.notificacoes.map { $0.categoria })).sorted { $0.rawValue < $1.rawValue }
    }
    
    // MARK: - Init (Ciclo de Vida)
    init(notificacaoVM: NotificacaoViewModel) {
        self.notificacaoVM = notificacaoVM
        print("🔵 HistoricoView init() - Carregando histórico")
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // MARK: - Filtros
                VStack(spacing: 10) {
                    // Modo de visualização
                    Picker("Visualização", selection: $modoVisualizacao) {
                        ForEach(ModoVisualizacao.allCases, id: \.self) { modo in
                            Text(modo.rawValue).tag(modo)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    
                    // Filtros horizontais
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(FiltroStatus.allCases, id: \.self) { status in
                                FilterButton(
                                    texto: status.rawValue,
                                    selecionado: filtroStatus == status,
                                    acao: { filtroStatus = status }
                                )
                            }
                            
                            ForEach(categoriasDisponiveis, id: \.self) { categoria in
                                FilterIconButton(
                                    icone: categoria.icone,
                                    selecionado: filtroCategoria == categoria,
                                    cor: corParaCategoria(categoria),
                                    acao: {
                                        filtroCategoria = (filtroCategoria == categoria) ? nil : categoria
                                    }
                                )
                            }
                            
                            if filtroCategoria != nil || filtroStatus != .todas {
                                Button("Limpar") {
                                    filtroCategoria = nil
                                    filtroStatus = .todas
                                }
                                .font(.caption)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.gray.opacity(0.2))
                                .foregroundColor(.primary)
                                .cornerRadius(15)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical, 10)
                .background(Color(.systemBackground))
                
                Divider()
                
                // MARK: - Conteúdo Principal
                if notificacoesFiltradas.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "bell.slash")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        
                        Text(filtroStatus == .todas ? "Nenhuma notificação" : "Nenhuma notificação encontrada")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        if filtroStatus != .todas || filtroCategoria != nil {
                            Text("Tente mudar os filtros")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(maxHeight: .infinity)
                } else {
                    switch modoVisualizacao {
                    case .lista:
                        ListaNotificacoesView(
                            notificacoes: notificacoesFiltradas,
                            notificacaoVM: notificacaoVM,
                            mostrarDetalhes: $mostrarDetalhes
                        )
                    case .calendario:
                        CalendarioView(
                            notificacoes: notificacoesFiltradas,
                            mostrarDetalhes: $mostrarDetalhes
                        )
                    }
                }
            }
            .navigationTitle("Histórico")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button {
                            exportarHistorico()
                        } label: {
                            Label("Exportar CSV", systemImage: "square.and.arrow.up")
                        }
                        
                        Button(role: .destructive) {
                            notificacaoVM.cancelarTodasNotificacoes()
                        } label: {
                            Label("Limpar Tudo", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            .sheet(item: $mostrarDetalhes) { notificacao in
                DetalhesNotificacaoView(
                    notificacao: notificacao,
                    notificacaoVM: notificacaoVM
                )
            }
        }
        .onAppear {
            print("🟢 HistoricoView onAppear() - Carregando \(notificacaoVM.notificacoes.count) notificações")
        }
        .onDisappear {
            print("🔴 HistoricoView onDisappear()")
        }
    }
    
    // MARK: - Private Methods
    
    private func exportarHistorico() {
        print("📤 Exportando histórico como CSV")
        
        var csv = "ID,Título,Mensagem,Data,Status,Categoria,Repetição,Badge\n"
        
        for notificacao in notificacoesFiltradas {
            let linha = [
                notificacao.id,
                notificacao.titulo.replacingOccurrences(of: ",", with: ";"),
                notificacao.mensagem.replacingOccurrences(of: ",", with: ";"),
                notificacaoVM.formatarData(notificacao.dataAgendamento),
                notificacao.status,
                notificacao.categoria.rawValue,
                notificacao.repetir.rawValue,
                notificacao.badge?.description ?? "0"
            ].joined(separator: ",")
            
            csv += linha + "\n"
        }
        
        // Aqui você poderia implementar compartilhamento do CSV
        print("✅ Histórico exportado (\(notificacoesFiltradas.count) registros)")
    }
    
    private func corParaCategoria(_ categoria: Notificacao.CategoriaNotificacao) -> Color {
        switch categoria.cor {
        case "azul": return .blue
        case "laranja": return .orange
        case "verde": return .green
        case "vermelho": return .red
        case "roxo": return .purple
        default: return .gray
        }
    }
}

// MARK: - Subviews

struct ListaNotificacoesView: View {
    let notificacoes: [Notificacao]
    let notificacaoVM: NotificacaoViewModel
    @Binding var mostrarDetalhes: Notificacao?
    
    var body: some View {
        List {
            ForEach(notificacoes) { notificacao in
                NotificacaoRowView(notificacao: notificacao)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        mostrarDetalhes = notificacao
                    }
                    .swipeActions(edge: .trailing) {
                        if notificacao.estaAtiva {
                            Button(role: .destructive) {
                                notificacaoVM.cancelarNotificacao(id: notificacao.id)
                            } label: {
                                Label("Cancelar", systemImage: "xmark.circle")
                            }
                        }
                    }
            }
        }
        .listStyle(.plain)
    }
}

struct NotificacaoRowView: View {
    let notificacao: Notificacao
    
    var body: some View {
        HStack(spacing: 12) {
            // Ícone da categoria
            Image(systemName: notificacao.categoria.icone)
                .font(.title3)
                .foregroundColor(corParaCategoria(notificacao.categoria))
                .frame(width: 40)
            
            // Conteúdo
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(notificacao.titulo)
                        .font(.headline)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Text(statusTexto)
                        .font(.caption2)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(statusCor.opacity(0.2))
                        .foregroundColor(statusCor)
                        .cornerRadius(4)
                }
                
                Text(notificacao.mensagem)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                HStack {
                    Text(formatarData(notificacao.dataAgendamento))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    if let badge = notificacao.badge, badge > 0 {
                        Text("🔢 \(badge)")
                            .font(.caption2)
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .padding(.vertical, 8)
    }
    
    private var statusTexto: String {
        notificacao.status
    }
    
    private var statusCor: Color {
        switch notificacao.status {
        case "Entregue": return .green
        case "Agendada": return .blue
        case "Expirada": return .gray
        default: return .orange
        }
    }
    
    private func formatarData(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM HH:mm"
        return formatter.string(from: date)
    }
    
    private func corParaCategoria(_ categoria: Notificacao.CategoriaNotificacao) -> Color {
        switch categoria.cor {
        case "azul": return .blue
        case "laranja": return .orange
        case "verde": return .green
        case "vermelho": return .red
        case "roxo": return .purple
        default: return .gray
        }
    }
}

struct CalendarioView: View {
    let notificacoes: [Notificacao]
    @Binding var mostrarDetalhes: Notificacao?
    
    var notificacoesPorDia: [Date: [Notificacao]] {
        Dictionary(grouping: notificacoes) { notificacao in
            Calendar.current.startOfDay(for: notificacao.dataAgendamento)
        }
    }
    
    var diasOrdenados: [Date] {
        notificacoesPorDia.keys.sorted(by: >)
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(diasOrdenados, id: \.self) { dia in
                    if let notificacoesDia = notificacoesPorDia[dia] {
                        DiaSectionView(
                            dia: dia,
                            notificacoes: notificacoesDia,
                            mostrarDetalhes: $mostrarDetalhes
                        )
                    }
                }
            }
            .padding()
        }
    }
}

struct DiaSectionView: View {
    let dia: Date
    let notificacoes: [Notificacao]
    @Binding var mostrarDetalhes: Notificacao?
    
    var diaFormatado: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d 'de' MMMM"
        return formatter.string(from: dia).capitalized
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(diaFormatado)
                .font(.headline)
                .padding(.horizontal)
            
            ForEach(notificacoes) { notificacao in
                NotificacaoCalendarCard(notificacao: notificacao)
                    .onTapGesture {
                        mostrarDetalhes = notificacao
                    }
            }
        }
    }
}

struct NotificacaoCalendarCard: View {
    let notificacao: Notificacao
    
    var body: some View {
        HStack {
            VStack {
                Text(horaFormatada)
                    .font(.system(.body, design: .monospaced))
                    .fontWeight(.semibold)
                Text("")
                    .font(.caption2)
            }
            .frame(width: 50)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(notificacao.titulo)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(notificacao.mensagem)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            Spacer()
            
            Image(systemName: notificacao.categoria.icone)
                .foregroundColor(corParaCategoria(notificacao.categoria))
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
    }
    
    private var horaFormatada: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: notificacao.dataAgendamento)
    }
    
    private func corParaCategoria(_ categoria: Notificacao.CategoriaNotificacao) -> Color {
        switch categoria.cor {
        case "azul": return .blue
        case "laranja": return .orange
        case "verde": return .green
        case "vermelho": return .red
        case "roxo": return .purple
        default: return .gray
        }
    }
}

struct FilterButton: View {
    let texto: String
    let selecionado: Bool
    let acao: () -> Void
    
    var body: some View {
        Button(action: acao) {
            Text(texto)
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(selecionado ? Color.blue : Color(.systemGray5))
                .foregroundColor(selecionado ? .white : .primary)
                .cornerRadius(15)
        }
    }
}

struct FilterIconButton: View {
    let icone: String
    let selecionado: Bool
    let cor: Color
    let acao: () -> Void
    
    var body: some View {
        Button(action: acao) {
            Image(systemName: icone)
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(selecionado ? cor.opacity(0.3) : Color(.systemGray5))
                .foregroundColor(selecionado ? cor : .primary)
                .cornerRadius(15)
        }
    }
}