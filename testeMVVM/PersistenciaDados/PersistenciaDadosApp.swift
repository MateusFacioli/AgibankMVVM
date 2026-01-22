//
//  PersistenciaDadosApp.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 22/01/26.
//


import SwiftUI

struct PersistenciaDadosApp: View {
    var body: some View {
        NavigationStack {
            PersistenciaView()
                .onAppear {
                    print("🚀 App de Persistência iniciado!")
                    print("📁 Document Directory:")
                    print("   \(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.path ?? "Não encontrado")")
                }
        }
    }
}
