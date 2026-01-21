//
//  CriarNotificacaoView.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 20/01/26.
//


import SwiftUI

struct CriarNotificacaoView: View {
    @ObservedObject var notificacaoVM: NotificacaoViewModel
    @Environment(\.dismiss) var dismiss
    @State private var titulo = ""
    @State private var mensagem = ""
    @State private var dataAgendamento = Date().addingTimeInterval(3600) // 1 hora depois
    @State private var repeticao: Notificacao.RepeticaoNotificacao = .nunca
    @State private var categoria: Notificacao.CategoriaNotificacao = .lembrete
    @State private var badgePersonalizado: String = ""
    @State private var mostrarPickerData = false
    @State private var mostrarPickerHora = false
    
    // MARK: - Computed Properties
    private var dataFormatada: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: dataAgendamento)
    }
    
    private var horaFormatada: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: dataAgendamento)
    }
    
    private var podeAgendar: Bool {
        !titulo.trimmingCharacters(in: .whitespaces).isEmpty &&
        !mensagem.trimmingCharacters(in: .whitespaces).isEmpty &&
        dataAgendamento > Date()
    }
    
    // MARK: - Init (Ciclo de Vida)
    init(notificacaoVM: NotificacaoViewModel) {
        self.notificacaoVM = notificacaoVM
        print("🔵 CriarNotificacaoView init() - Inicializando formulário")
    }
    
    var body: some View {
        NavigationStack {
            Form {
                // MARK: - Seção: Informações Básicas
                Section("Detalhes da Notificação") {
                    TextField("Título", text: $titulo)
                        .onChange(of: titulo) { valorAntigo, valorNovo in
                            print("✏️ Título alterado: '\(valorAntigo)' → '\(valorNovo)'")
                        }
                    
                    TextField("Mensagem", text: $mensagem, axis: .vertical)
                        .lineLimit(3...6)
                        .onChange(of: mensagem) { valorAntigo, valorNovo in
                            print("📝 Mensagem alterada: \(valorNovo.count) caracteres")
                        }
                }
                
                // MARK: - Seção: Data e Hora
                Section("Agendamento") {
                    HStack {
                        Text("Data")
                        Spacer()
                        Button(dataFormatada) {
                            mostrarPickerData = true
                        }
                        .foregroundColor(.blue)
                    }
                    
                    HStack {
                        Text("Hora")
                        Spacer()
                        Button(horaFormatada) {
                            mostrarPickerHora = true
                        }
                        .foregroundColor(.blue)
                    }
                    
                    // Picker embutido para backup
                    DatePicker("", selection: $dataAgendamento, displayedComponents: [.date, .hourAndMinute])
                        .datePickerStyle(.compact)
                        .labelsHidden()
                        .onChange(of: dataAgendamento) { valorAntigo, valorNovo in
                            print("📅 Data alterada: \(valorAntigo) → \(valorNovo)")
                        }
                }
                
                // MARK: - Seção: Configurações
                Section("Configurações") {
                    Picker("Repetir", selection: $repeticao) {
                        ForEach(Notificacao.RepeticaoNotificacao.allCases, id: \.self) { rep in
                            Text(rep.rawValue).tag(rep)
                        }
                    }
                    .onChange(of: repeticao) { valorAntigo, valorNovo in
                        print("🔄 Repetição alterada: \(valorAntigo.rawValue) → \(valorNovo.rawValue)")
                    }
                    
                    Picker("Categoria", selection: $categoria) {
                        ForEach(Notificacao.CategoriaNotificacao.allCases, id: \.self) { cat in
                            Label(cat.rawValue, systemImage: cat.icone).tag(cat)
                        }
                    }
                    .onChange(of: categoria) { valorAntigo, valorNovo in
                        print("🏷️ Categoria alterada: \(valorAntigo.rawValue) → \(valorNovo.rawValue)")
                    }
                    
                    TextField("Badge (opcional)", text: $badgePersonalizado)
                        .keyboardType(.numberPad)
                        .onChange(of: badgePersonalizado) { valorAntigo, valorNovo in
                            print("🔢 Badge personalizado: \(valorNovo)")
                        }
                }
                
                // MARK: - Seção: Ação
                Section {
                    Button {
                        agendarNotificacao()
                    } label: {
                        HStack {
                            Spacer()
                            Label("Agendar Notificação", systemImage: "bell.badge.fill")
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(!podeAgendar || notificacaoVM.estaAgendando)
                    .listRowBackground(Color.clear)
                    
                    if notificacaoVM.estaAgendando {
                        HStack {
                            Spacer()
                            ProgressView()
                                .padding(.trailing, 5)
                            Text("Agendando...")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                    }
                }
                
                // MARK: - Seção: Visualização
                Section("Pré-visualização") {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Como vai aparecer:")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        HStack {
                            Image(systemName: categoria.icone)
                                .foregroundColor(corParaCategoria(categoria))
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(titulo.isEmpty ? "[Título]" : titulo)
                                    .font(.headline)
                                Text(mensagem.isEmpty ? "[Mensagem]" : mensagem)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .lineLimit(2)
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        
                        Text("Data: \(dataFormatada) às \(horaFormatada)")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        
                        if let badgeInt = Int(badgePersonalizado), badgeInt > 0 {
                            Text("Badge: \(badgeInt)")
                                .font(.caption2)
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .navigationTitle("Nova Notificação")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        print("❌ Cancelando criação de notificação")
                        dismiss()
                    }
                }
            }
            // MARK: - Sheets para seleção de data/hora
            .sheet(isPresented: $mostrarPickerData) {
                DatePickerSheet(
                    titulo: "Selecionar Data",
                    modo: .data,
                    selecao: $dataAgendamento
                )
            }
            .sheet(isPresented: $mostrarPickerHora) {
                DatePickerSheet(
                    titulo: "Selecionar Hora",
                    modo: .hora,
                    selecao: $dataAgendamento
                )
            }
        }
        // MARK: - Ciclo de Vida da View
        .onAppear {
            print("🟢 CriarNotificacaoView onAppear() - Formulário aberto")
        }
        .onDisappear {
            print("🔴 CriarNotificacaoView onDisappear() - Formulário fechado")
        }
    }
    
    // MARK: - Private Methods
    
    private func agendarNotificacao() {
        print("📝 Iniciando agendamento de notificação")
        
        // Converter badge personalizado para Int (se fornecido)
        let badge: Int? = Int(badgePersonalizado)
        
        // Agendar notificação através do ViewModel
        notificacaoVM.agendarNotificacao(
            titulo: titulo,
            mensagem: mensagem,
            data: dataAgendamento,
            repetir: repeticao,
            categoria: categoria,
            badge: badge
        )
        
        // Fechar a view após agendamento bem-sucedido
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            if !notificacaoVM.estaAgendando {
                dismiss()
            }
        }
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

// MARK: - Componente para seleção de data/hora
struct DatePickerSheet: View {
    let titulo: String
    let modo: ModoSelecao
    @Binding var selecao: Date
    @Environment(\.dismiss) var dismiss
    
    enum ModoSelecao {
        case data, hora
    }
    
    var displayedComponents: DatePickerComponents {
        switch modo {
        case .data: return .date
        case .hora: return .hourAndMinute
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                DatePicker(
                    titulo,
                    selection: $selecao,
                    displayedComponents: displayedComponents
                )
                .datePickerStyle(.wheel)
                .padding()
                
                Spacer()
            }
            .navigationTitle(titulo)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("OK") {
                        dismiss()
                    }
                }
            }
        }
        .presentationDetents([.height(350)])
    }
}