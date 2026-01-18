//
//  PermissaoCalendarioApp.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 18/01/26.
//


import SwiftUI

struct PermissaoCalendarioApp: View {
    var body: some View {
        NavigationStack {
            PermissoesView()
                .navigationTitle("Calendário permissão")
        }
    }
}
