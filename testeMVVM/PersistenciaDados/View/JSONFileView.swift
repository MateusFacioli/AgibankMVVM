//
//  JSONFileView.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 22/01/26.
//

import SwiftUI

/// View simplificada para salvar JSON no Desktop do Mac
struct JSONFileView: View {
    @ObservedObject var viewModel: PersistenciaViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // MARK: - Cabeçalho
                VStack(spacing: 8) {
                    Image(systemName: "desktopcomputer")
                        .font(.largeTitle)
                        .foregroundColor(.blue)
                    
                    Text("JSON no Desktop")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    #if targetEnvironment(macCatalyst) || os(macOS)
                    Text("Salvando no Desktop do Mac")
                        .font(.caption)
                        .foregroundColor(.blue)
                    #else
                    Text("Salvando no Documents do App")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    #endif
                }
                .padding(.top)
                
                // MARK: - Status do Arquivo
                VStack(spacing: 12) {
                    Text("Status")
                        .font(.headline)
                    
                    HStack {
                        Text("Arquivo existe?")
                        Spacer()
                        Text(viewModel.jsonFileExiste() ? "✅ Sim" : "❌ Não")
                            .foregroundColor(viewModel.jsonFileExiste() ? .green : .red)
                    }
                    
                    HStack {
                        Text("Usuários salvos:")
                        Spacer()
                        Text("\(viewModel.usuariosJSON.count)")
                            .fontWeight(.bold)
                    }
                    
                    #if targetEnvironment(macCatalyst) || os(macOS)
                    Text("Local: Desktop do Mac")
                        .font(.caption)
                        .foregroundColor(.blue)
                    #else
                    Text("Local: Documents do App")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    #endif
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal)
                
                // MARK: - Formulário de Usuário
                VStack(spacing: 16) {
                    Text("Novo Usuário")
                        .font(.headline)
                    
                    TextField("Nome", text: $viewModel.usuarioAtual.nome)
                        .textFieldStyle(.roundedBorder)
                    
                    TextField("Email", text: $viewModel.usuarioAtual.email)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.emailAddress)
                    
                    HStack {
                        Text("Idade:")
                        TextField("Idade", value: $viewModel.usuarioAtual.idade, formatter: NumberFormatter())
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.numberPad)
                            .frame(width: 60)
                        Text("anos")
                    }
                    
                    Toggle("Ativo", isOn: $viewModel.usuarioAtual.ativo)
                    
                    Button {
                        viewModel.adicionarUsuarioJSON()
                    } label: {
                        Label("Adicionar Usuário", systemImage: "person.badge.plus")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                    .disabled(viewModel.usuarioAtual.nome.isEmpty)
                }
                .padding()
                .background(Color.gray.opacity(0.05))
                .cornerRadius(12)
                .padding(.horizontal)
                
                // MARK: - Lista de Usuários
                if !viewModel.usuariosJSON.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Usuários (\(viewModel.usuariosJSON.count))")
                            .font(.headline)
                        
                        ForEach(viewModel.usuariosJSON) { usuario in
                            UsuarioRow(usuario: usuario)
                                .swipeActions {
                                    Button(role: .destructive) {
                                        if let index = viewModel.usuariosJSON.firstIndex(where: { $0.id == usuario.id }) {
                                            viewModel.removerUsuarioJSON(at: index)
                                        }
                                    } label: {
                                        Label("Remover", systemImage: "trash")
                                    }
                                }
                        }
                    }
                    .padding()
                    .background(Color.blue.opacity(0.05))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
                
                // MARK: - Controles do Arquivo
                VStack(spacing: 12) {
                    HStack(spacing: 12) {
                        Button {
                            viewModel.carregarUsuariosJSON()
                        } label: {
                            Label("Carregar", systemImage: "square.and.arrow.down")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                        
                        Button {
                            viewModel.salvarUsuariosJSON()
                        } label: {
                            Label("Salvar", systemImage: "square.and.arrow.up")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.blue)
                    }
                    
                    HStack(spacing: 12) {
                        Button {
                            viewModel.copiarCaminhoJSON()
                        } label: {
                            Label("Copiar Caminho", systemImage: "doc.on.doc")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                        
                        Button {
                            viewModel.mostrarInfoArquivo()
                        } label: {
                            Label("Info", systemImage: "info.circle")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                    }
                    
                    Button(role: .destructive) {
                        viewModel.deletarArquivoJSON()
                    } label: {
                        Label("Deletar Arquivo", systemImage: "trash")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                }
                .padding(.horizontal)
                
                // MARK: - Mensagem de Status
                if !viewModel.mensagemStatus.isEmpty {
                    Text(viewModel.mensagemStatus)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.05))
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
                
                // MARK: - Explicação
                VStack(alignment: .leading, spacing: 8) {
                    Text("💡 Como funciona:")
                        .font(.headline)
                    
                    #if targetEnvironment(macCatalyst) || os(macOS)
                    Text("• Arquivo salvo no Desktop do Mac")
                        .font(.caption)
                    Text("• Facilita acesso e backup")
                        .font(.caption)
                    Text("• JSON estruturado e legível")
                        .font(.caption)
                    #else
                    Text("• Arquivo salvo no Documents do App")
                        .font(.caption)
                    Text("• Persistência entre sessões")
                        .font(.caption)
                    Text("• JSON estruturado e legível")
                        .font(.caption)
                    #endif
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
    }
}

/// Componente para exibir uma linha de usuário
struct UsuarioRow: View {
    let usuario: Usuario
    
    var body: some View {
        HStack {
            Image(systemName: usuario.ativo ? "person.circle.fill" : "person.circle")
                .foregroundColor(usuario.ativo ? .blue : .gray)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(usuario.nome)
                    .font(.headline)
                
                HStack {
                    Text(usuario.email)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text("\(usuario.idade) anos")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            Text(usuario.ativo ? "Ativo" : "Inativo")
                .font(.caption2)
                .foregroundColor(usuario.ativo ? .green : .red)
        }
        .padding(.vertical, 8)
    }
}
