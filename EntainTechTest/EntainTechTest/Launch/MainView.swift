//
//  MainView.swift
//  EntainTechTest
//
//  Created by David Wright on 25/4/2025.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        let dependencyGraph = DependencyGraphImpl()
        LaunchView(dependncuyGraph: dependencyGraph, viewModel: .init())
    }
}

#Preview {
    MainView()
}
