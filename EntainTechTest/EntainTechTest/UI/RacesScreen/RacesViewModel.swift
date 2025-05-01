//
//  RacesViewModel.swift
//  EntainTechTest
//
//  Created by David Wright on 26/4/2025.
//

import Combine
import Foundation

typealias PublisherTimer = Publishers.Autoconnect<Timer.TimerPublisher>

@MainActor
class RacesViewModel: ObservableObject {
    private var getRacesDataUseCase: GetRacesDataUseCase

    @Published private var raceInformation: RaceInformation?
    var selectedRaceType: RaceCategoryTypeModel = .all
    var races: [RaceViewModel] = []

    private var cancellables = Set<AnyCancellable>()

    var raceTimers: [RaceTimer] {
        raceInformation?.races.map { race in
            let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
            return RaceTimer(timer: timer, raceID: race.raceId)
        } ?? []
    }

    var navigationTitle: String { "races.view.navigation.title".localized() }

    func pickerItemAccessibilityLabel(raceType: RaceCategoryTypeModel) -> String {
        "races.view.picker.item.\(raceType.description).accessibilityLabel".localized()
    }

    init(getRacesDataUseCase: GetRacesDataUseCase) {
        self.getRacesDataUseCase = getRacesDataUseCase

        Task {
            self.raceInformation = try? await getRaceInformation()
            self.update()
        }
    }

    private func removeRace(with raceID: String) async throws {
        raceInformation?.races = raceInformation?.races.filter { $0.raceId != raceID } ?? []
        if let information = raceInformation, information.races.count < 5 {
            raceInformation = try? await getRaceInformation()
        }
        update()
    }

    private func getRaceInformation() async throws -> RaceInformation? {
        try? await self.getRacesDataUseCase.invoke(with: selectedRaceType)
    }

    private func update() {
        self.races = raceInformation?.races.map {
            let raceviewModel = RaceViewModel(
                raceID: $0.raceId,
                meetingName: $0.meetingName,
                raceNumber: $0.raceNumber,
                advertisedStartTime: $0.advertisedStart.raceDateTime,
                raceCategory: $0.category,
                timer: timerForRace($0)
            )
            observeRaceEnding(raceviewModel)
            return raceviewModel
        } ?? []
    }

    private func observeRaceEnding(_ race: RaceViewModel) {
        race.$shouldRemove.filter { $0 }.sink { [weak self] _ in
            Task {
                try? await self?.removeRace(with: race.raceID)
            }
        }.store(in: &cancellables)
    }

    private func timerForRace(_ race: RaceSummaryModel) -> PublisherTimer {
        raceTimers.first(where: { $0.raceID == race.raceId })?.timer ??
        Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    }

    func filter(_ category: RaceCategoryTypeModel) {
        selectedRaceType = category
        Task {
            self.raceInformation = try? await getRaceInformation()
            self.update()
        }
    }
}

struct RaceTimer {
    let timer: PublisherTimer
    let raceID: String
}

class RaceViewModel: ObservableObject, Identifiable, Equatable {
    let id = UUID()

    @Published var shouldRemove = false
    @Published var timeRemaining: TimeInterval

    let raceID: String
    let raceCategory: RaceCategoryTypeModel
    let meetingName: String
    let raceNumber: Int
    let advertisedStartTime: Date
    let timer: PublisherTimer

    var raceNumberString: String { "\("race.view.race.number".localized())\(raceNumber)" }
    var timeToGoString: String { raceTimeFormatter.string(from: Double(timeRemaining)) ?? "" }
    var hasGone: Bool { timeRemaining < -60 }

    init(
        raceID: String,
        meetingName: String,
        raceNumber: Int,
        advertisedStartTime: Date?,
        raceCategory: RaceCategoryTypeModel,
        timer: PublisherTimer
    ) {
        self.raceID = raceID
        self.meetingName = meetingName
        self.raceNumber = raceNumber
        self.advertisedStartTime = advertisedStartTime ?? Date()
        self.raceCategory = raceCategory
        self.timer = timer
        self.timeRemaining = abs(Date().timeIntervalSince1970 - self.advertisedStartTime.timeIntervalSince1970)
    }

    func handleRaceTime() -> TimeInterval {
        if hasGone {
            removeRace()
        } else {
            timeRemaining -= 1
        }
        return timeRemaining
    }

    func removeRace() {
        timer.upstream.connect().cancel()
        shouldRemove = true
    }

    static func == (lhs: RaceViewModel, rhs: RaceViewModel) -> Bool { lhs.id == rhs.id }
}

extension RaceViewModel {
    var raceTimeFormatter: DateComponentsFormatter {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .dropLeading
        return formatter
    }
}

// Accessibility

extension RaceViewModel {
    var raceCategoryAccessibilityLabel: String { "race.view.race.type.\(raceCategory.description)".localized() }
    var raceTimerAccessibilityLabel: String {
        if timeRemaining < 0 {
            return "race.view.timer.jumped".localized()
        } else {
            var minutes: String {
                (Int(timeRemaining) / 60) % 60 > 0 ? "\((Int(timeRemaining) / 60) % 60)" : ""
            }
            var seconds: String {
                "\(Int(timeRemaining) % 60)"
            }
            if minutes.isEmpty {
                return "\(seconds) \("race.view.timer.timeToGo".localized())"
            } else {
                return "\(minutes) \("race.view.timer.middle".localized()) \(seconds) \("race.view.timer.timeToGo".localized())"
            }
        }
    }
}
