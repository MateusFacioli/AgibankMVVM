//
//  MapsViewController.swift
//  testeMVVM
//
//  Created by Maurício Fonseca on 13/01/26.
//

import SwiftUI
import MapKit

struct MapsViewController<Content: View>: View {
    @EnvironmentObject var mapsCoordinator: MapsCoordinator

    // Content da tela que quer usar o fluxo de localização
    let content: Content

    // Bind compartilhado para padrão binding
    @State private var bindingCoordinate: LocationModel? = nil

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .sheet(item: $mapsCoordinator.activeSheet) { route in
                switch route {
                case .locationCallback:
                    LocationView(onLocationPicked: { coord in
                        mapsCoordinator.pickedCoordinate = coord
                        mapsCoordinator.dismiss()
                    })
                case .locationShared:
                    LocationView(externalVM: mapsCoordinator.sharedLocationVM)
                        .onDisappear {
                            // Ao fechar, capturamos do shared VM
                            if let coord = mapsCoordinator.sharedLocationVM.savedCoordinate {
                                mapsCoordinator.pickedCoordinate = coord
                            }
                        }
                case .locationBinding:
                    LocationView(selectedCoordinate: $bindingCoordinate)
                        .onChange(of: bindingCoordinate) { _, newValue in
                            if let coord = newValue {
                                mapsCoordinator.pickedCoordinate = coord
                            }
                        }
                }
            }
    }
}
