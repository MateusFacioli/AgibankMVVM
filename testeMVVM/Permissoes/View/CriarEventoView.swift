//
//  CriarEventoView.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 18/01/26.
//


import SwiftUI

struct CriarEventoView: View {
    @ObservedObject var viewModel: CalendarioViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var titulo = ""
    @State private var descricao = ""
    @State private var dataInicio = Date().addingTimeInterval(3600)
    @State private var dataFim = Date().addingTimeInterval(7200)
    @State private var local = ""
    @State private var mostrarSucesso = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Detalhes do Evento") {
                    TextField("Título do Evento", text: $titulo)
                    TextField("Descrição", text: $descricao)
                    TextField("Local", text: $local)
                }
                
                Section("Data e Hora") {
                    DatePicker("Início", selection: $dataInicio)
                    DatePicker("Término", selection: $dataFim)
                }
                
                Section {
                    Button {
                        criarEvento()
                    } label: {
                        HStack {
                            Spacer()
                            Label("Criar Evento", systemImage: "calendar.badge.plus")
                            Spacer()
                        }
                    }
                    .disabled(titulo.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .navigationTitle("Novo Evento")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
            }
            .alert("Evento Criado!", isPresented: $mostrarSucesso) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text("Seu evento foi adicionado ao calendário com sucesso!")
            }
        }
    }
    
    private func criarEvento() {
        let evento = Evento(
            titulo: titulo,
            descricao: descricao,
            dataInicio: dataInicio,
            dataFim: dataFim,
            local: local
        )
        
        let resultado = viewModel.criarEvento(evento)
        
        switch resultado {
        case .success:
            mostrarSucesso = true
        case .failure(let error):
            print("Erro ao criar evento: \(error)")
        }
    }
}
