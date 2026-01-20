//
//  EtapaCardView.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 20/01/26.
//


import SwiftUI

struct EtapaCardView: View {
    let etapa: EtapaCiclo
    let isExpanded: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                Image(systemName: etapa.icone)
                    .font(.title3)
                    .foregroundColor(etapa.corSwiftUI)
                    .frame(width: 40)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(etapa.nome)
                        .font(.headline)
                        .foregroundColor(etapa.corSwiftUI)
                    
                    Text(etapa.momento.rawValue)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .foregroundColor(.gray)
            }
            
            // Descrição expandida
            if isExpanded {
                Divider()
                
                Text(etapa.descricao)
                    .font(.body)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
                
                HStack {
                    Spacer()
                    Text("Ordem: \(etapa.ordem)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(etapa.corSwiftUI.opacity(0.3), lineWidth: 1)
        )
    }
}