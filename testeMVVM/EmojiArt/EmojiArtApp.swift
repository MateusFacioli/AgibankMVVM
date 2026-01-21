//
//  EmojiArtApp.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 21/01/26.
//


import SwiftUI

struct EmojiArtApp: View {
    var body: some View {
        NavigationStack {
            ContentEmojiView()
                .onAppear {
                    print("🎨 App EmojiArt iniciado!")
                    print("👉 Toque para adicionar emojis")
                    print("👉 Arraste para mover")
                    print("👉 Toque longo para controles")
                }
        }
    }
}
