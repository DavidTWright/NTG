//
//  LaunchView.swift
//  EntainTechTest
//
//  Created by David Wright on 26/4/2025.
//

import SwiftUI

struct LaunchView: View {
    let dependncuyGraph: DependencyGraph
    let viewModel: LaunchViewModel

    @State private var isRacesScreenPresented = false

    var body: some View {
        ZStack {
            Rectangle().fill(MobileDesignSystem.ntgColor)
            VStack(alignment: .center) {
                LaunchViewButton(title: viewModel.buttonTitle) {
                    isRacesScreenPresented.toggle()
                }
                .padding(.init(
                    top: 400,
                    leading: 0,
                    bottom: 0,
                    trailing: 0)
                )
                .sheet(isPresented: $isRacesScreenPresented) {
                    RacesView(
                        viewModel: .init(
                            getRacesDataUseCase: dependncuyGraph.useCases.getRaceDataUseCase
                        )
                    )
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    LaunchView(dependncuyGraph: DependencyGraphImpl(), viewModel: .init())
}

struct LaunchViewButton: View {
    let title: String
    let action: () -> Void
    var body: some View {
        VStack(alignment: .center) {
            Button {
                action()
            } label: {
                Text(title)
                    .frame(
                        minWidth: 200,
                        minHeight: 50
                    )
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.white)
                            .stroke(MobileDesignSystem.ntgColor, style: .init(lineWidth: 1))
                    )
                    .foregroundStyle(MobileDesignSystem.ntgColor)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }

    init(title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
}
