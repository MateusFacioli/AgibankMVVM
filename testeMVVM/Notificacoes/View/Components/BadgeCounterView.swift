////
////  BadgeCounterView.swift
////  testeMVVM
////
////  Created by Mateus Rodrigues on 20/01/26.
////
//
//
//import SwiftUI
//
//struct BadgeCounterView: View {
//    let badgeCount: Int
//    @State private var animating = false
//    
//    var body: some View {
//        VStack(spacing: 15) {
//            Text("BADGE NA BANDEJA")
//                .font(.caption)
//                .fontWeight(.semibold)
//                .foregroundColor(.secondary)
//            
//            ZStack {
//                // Círculo de fundo
//                Circle()
//                    .fill(Color.red.gradient)
//                    .frame(width: 120, height: 120)
//                    .shadow(color: .red.opacity(0.3), radius: 10, y: 5)
//                    .scaleEffect(animating ? 1.05 : 1.0)
//                    .animation(
//                        Animation.easeInOut(duration: 1.0)
//                            .repeatForever(autoreverses: true),
//                        value: animating
//                    )
//                
//                // Número do badge
//                Text("\(badgeCount)")
//                    .font(.system(size: 50, weight: .bold, design: .rounded))
//                    .foregroundColor(.white)
//                    .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
//                
//                // Ícone do app
//                Image(systemName: "app.fill")
//                    .font(.system(size: 30))
//                    .foregroundColor(.white.opacity(0.8))
//                    .offset(y: -45)
//            }
//            
//            Text("Este número aparece na bandeja do app")
//                .font(.caption2)
//                .foregroundColor(.secondary)
//                .multilineTextAlignment(.center)
//                .padding(.horizontal, 40)
//            
//            // Indicador visual da bandeja do app
//            HStack(spacing: 5) {
//                ForEach(0..<3) { _ in
//                    RoundedRectangle(cornerRadius: 2)
//                        .fill(Color.gray.opacity(0.3))
//                        .frame(width: 20, height: 4)
//                }
//            }
//            .padding(.top, 5)
//        }
//        .padding()
//        .background(
//            RoundedRectangle(cornerRadius: 16)
//                .fill(Color(.systemBackground))
//                .shadow(color: .black.opacity(0.05), radius: 10, y: 5)
//        )
//        .onAppear {
//            animating = true
//        }
//    }
//}
