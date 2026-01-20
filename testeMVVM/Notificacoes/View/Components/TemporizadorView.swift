//
//  TemporizadorView.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 20/01/26.
//


import SwiftUI

struct TemporizadorView: View {
    @Binding var tempoRestante: TimeInterval
    @State private var tempoDecorrido: TimeInterval = 0
    @State private var timerAtivo = false
    let onCompletar: () -> Void
    
    var tempoFormatado: String {
        let minutos = Int(tempoRestante) / 60
        let segundos = Int(tempoRestante) % 60
        return String(format: "%02d:%02d", minutos, segundos)
    }
    
    var progresso: Double {
        guard tempoDecorrido > 0 else { return 0 }
        return 1.0 - (tempoRestante / tempoDecorrido)
    }
    
    var body: some View {
        VStack(spacing: 15) {
            // Timer visual
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 10)
                    .frame(width: 120, height: 120)
                
                Circle()
                    .trim(from: 0, to: progresso)
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: [.blue, .green, .yellow, .red]),
                            center: .center
                        ),
                        style: StrokeStyle(lineWidth: 10, lineCap: .round)
                    )
                    .frame(width: 120, height: 120)
                    .rotationEffect(.degrees(-90))
                
                Text(tempoFormatado)
                    .font(.system(size: 24, weight: .bold, design: .monospaced))
            }
            
            // Controles
            HStack(spacing: 20) {
                Button {
                    if timerAtivo {
                        pararTimer()
                    } else {
                        iniciarTimer()
                    }
                } label: {
                    Image(systemName: timerAtivo ? "pause.circle.fill" : "play.circle.fill")
                        .font(.title)
                }
                
                Button {
                    resetarTimer()
                } label: {
                    Image(systemName: "arrow.counterclockwise.circle.fill")
                        .font(.title)
                }
            }
            .foregroundColor(.blue)
            
            // Status
            Text(timerAtivo ? "Contando..." : "Pausado")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
        .onDisappear {
            pararTimer()
        }
    }
    
    private func iniciarTimer() {
        timerAtivo = true
        tempoDecorrido = tempoRestante
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if tempoRestante > 0 {
                tempoRestante -= 1
            } else {
                timer.invalidate()
                timerAtivo = false
                onCompletar()
            }
        }
    }
    
    private func pararTimer() {
        timerAtivo = false
    }
    
    private func resetarTimer() {
        tempoRestante = tempoDecorrido
        timerAtivo = false
    }
}