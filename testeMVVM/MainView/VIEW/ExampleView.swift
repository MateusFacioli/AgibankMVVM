import SwiftUI

struct ExampleView: View {
    @EnvironmentObject private var coordinator: MainCoordinator
    
    var body: some View {
        List {
            Section("C.R.U.D.") {
                Button("Criar galpão") {
                    coordinator.navigate(to: .create)
                }
                Button("Remover galpão") {
                    coordinator.navigate(to: .remove)
                }
                Button("Atualizar galpão") {
                    coordinator.navigate(to: .update)
                }
                Button("Consultar galpão") {
                    coordinator.navigate(to: .consult)
                }
            }
        }
        .navigationTitle("Ex mvvm")
    }
}

#Preview {
    ExampleView()
}
