//
//  DadosCiclo.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 20/01/26.
//


/// Dados padrão para o ciclo de vida
struct DadosCiclo {
    static let etapas: [EtapaCiclo] = [
        // MARK: - SwiftUI
        EtapaCiclo(
            nome: "init()",
            descricao: "View struct é inicializada. Configuração inicial.",
            momento: .inicializacao,
            cor: "azul",
            icone: "bolt.fill",
            ordem: 1
        ),
        EtapaCiclo(
            nome: "body computed",
            descricao: "Propriedade body é calculada pela primeira vez.",
            momento: .inicializacao,
            cor: "azul",
            icone: "rectangle.fill",
            ordem: 2
        ),
        EtapaCiclo(
            nome: "onAppear",
            descricao: "View aparece na tela. Bom para carregar dados.",
            momento: .aparecimento,
            cor: "verde",
            icone: "eye.fill",
            ordem: 3
        ),
        EtapaCiclo(
            nome: "task (async)",
            descricao: "Executa tarefas assíncronas quando a view aparece.",
            momento: .aparecimento,
            cor: "verde",
            icone: "arrow.triangle.2.circlepath",
            ordem: 4
        ),
        EtapaCiclo(
            nome: "onChange",
            descricao: "Observa mudanças em propriedades @State/@Published.",
            momento: .aparecimento,
            cor: "laranja",
            icone: "arrow.left.arrow.right",
            ordem: 5
        ),
        EtapaCiclo(
            nome: "onDisappear",
            descricao: "View desaparece da tela. Limpeza de recursos.",
            momento: .desaparecimento,
            cor: "vermelho",
            icone: "eye.slash.fill",
            ordem: 6
        ),
        
        // MARK: - UIKit Equivalent
        EtapaCiclo(
            nome: "viewDidLoad",
            descricao: "UIKit: View Controller carregado na memória.",
            momento: .inicializacao,
            cor: "roxo",
            icone: "square.and.arrow.down.fill",
            ordem: 7
        ),
        EtapaCiclo(
            nome: "viewWillAppear",
            descricao: "UIKit: View está prestes a aparecer.",
            momento: .aparecimento,
            cor: "roxo",
            icone: "eye",
            ordem: 8
        ),
        EtapaCiclo(
            nome: "viewDidAppear",
            descricao: "UIKit: View apareceu completamente.",
            momento: .aparecimento,
            cor: "roxo",
            icone: "checkmark.circle.fill",
            ordem: 9
        ),
        EtapaCiclo(
            nome: "viewWillDisappear",
            descricao: "UIKit: View está prestes a desaparecer.",
            momento: .desaparecimento,
            cor: "roxo",
            icone: "xmark.circle.fill",
            ordem: 10
        ),
        EtapaCiclo(
            nome: "viewDidDisappear",
            descricao: "UIKit: View desapareceu completamente.",
            momento: .desaparecimento,
            cor: "roxo",
            icone: "xmark.circle",
            ordem: 11
        ),
        
        // MARK: - App Lifecycle
        EtapaCiclo(
            nome: "scenePhase",
            descricao: "SwiftUI: Detecta quando app vai para background/foreground.",
            momento: .background,
            cor: "laranja",
            icone: "app.badge.fill",
            ordem: 12
        ),
        EtapaCiclo(
            nome: "NotificationCenter",
            descricao: "Observa notificações do sistema como willResignActive.",
            momento: .background,
            cor: "laranja",
            icone: "bell.fill",
            ordem: 13
        ),
        EtapaCiclo(
            nome: "deinit",
            descricao: "View é destruída da memória. Última chance para limpeza.",
            momento: .destruicao,
            cor: "vermelho",
            icone: "trash.fill",
            ordem: 14
        )
    ]
}
