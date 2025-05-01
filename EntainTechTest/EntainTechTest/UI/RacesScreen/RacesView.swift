//
//  RacesView.swift
//  EntainTechTest
//
//  Created by David Wright on 26/4/2025.
//

import Combine
import SwiftUI

struct RacesView: View {
    @ObservedObject var viewModel: RacesViewModel
    @State private var raceType: RaceCategoryTypeModel = .all

    var body: some View {
        VStack {
            NavigationStack {
                VStack(alignment: .center, spacing: 10) {
                    Picker("Race Type", selection: $raceType) {
                        ForEach(RaceCategoryTypeModel.allCases) { raceType in
                            Image(systemName: raceType.iconName).tag(raceType)
                                .accessibilityLabel(viewModel.pickerItemAccessibilityLabel(raceType: raceType))
                        }
                    }
                    .pickerStyle(.segmented)
                    .background(MobileDesignSystem.ntgColor)
                    .padding(15)
                    .onChange(of: raceType) {
                        viewModel.filter(raceType)
                    }

                    ScrollView {
                        VStack(alignment: .leading, spacing: -10) {
                            ForEach(viewModel.races) { raceViewModel in
                                RaceView(viewModel: raceViewModel)
                                    .padding(10)
                                    .accessibilityElement(children: .combine)
                            }
                        }
                    }
                    .navigationTitle(viewModel.navigationTitle)
                    .foregroundStyle(MobileDesignSystem.ntgColor)
                }
            }
            .refreshable {
                viewModel.filter(raceType)
            }
        }
        .background {
            Rectangle().fill(MobileDesignSystem.ntgColor)
        }
    }
}

struct RaceView: View {
    @ObservedObject var viewModel: RaceViewModel
    @State private var timeRemaining: TimeInterval?
    var body: some View {
        HStack {
            Image(systemName: viewModel.raceCategory.iconName)
                .resizable()
                .frame(maxWidth: 35, maxHeight: 35)
                .foregroundStyle(.white)
                .padding(.init(
                    top: 0,
                    leading: 8,
                    bottom: 0,
                    trailing: 0
                ))
                .accessibilityLabel(viewModel.raceCategoryAccessibilityLabel)
            VStack(alignment: .leading, spacing: 2) {
                Text(viewModel.meetingName)
                    .font(.headline)
                Text("\(viewModel.raceNumberString)")
                    .font(.body)
            }
            .foregroundStyle(.white)
            .padding( .init(
                top: 5,
                leading: 8,
                bottom: 5,
                trailing: 8
            ))
            Spacer()
            Text("\(viewModel.timeToGoString)")
                .font(.body)
                .foregroundStyle(.white)
                .padding(10)
                .accessibilityLabel(viewModel.raceTimerAccessibilityLabel)
        }
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(MobileDesignSystem.ntgColor)
                .stroke(Color.white, lineWidth: 1)
        )
        .onReceive(viewModel.timer) { _ in
            if timeRemaining == nil {
                timeRemaining = viewModel.timeRemaining
            }
            timeRemaining = viewModel.handleRaceTime()
        }
    }
}

#Preview {
    Text("Import a mock here")
}
