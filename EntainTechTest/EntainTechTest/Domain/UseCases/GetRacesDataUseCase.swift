//
//  GetRacesDataUseCase.swift
//  EntainTechTest
//
//  Created by David Wright on 25/4/2025.
//

import Foundation

protocol GetRacesDataUseCase: Sendable {
    func invoke(with category: RaceCategoryTypeModel) async throws -> RaceInformation?
}

final class GetRacesDataUseCaseImpl: GetRacesDataUseCase {
    let racesDataRepository: RacesDataRepository

    func invoke(with category: RaceCategoryTypeModel) async throws -> RaceInformation? {
        var maxCallCount = 10
        var raceSummaries = try await racesDataRepository.fetchRaceData(resetFetchCount: true)?.racesData.raceSummaries
            .filter(for: category)
            .removeOldRaces()
            .sortByStartTime()
        while raceSummaries?.count ?? 0 < 5, maxCallCount > 0 {
            maxCallCount -= 1
            raceSummaries = try await racesDataRepository.fethMoreRaceData()?.racesData.raceSummaries
                .filter(for: category)
                .removeOldRaces()
                .sortByStartTime()
        }
        if (raceSummaries ?? []).count >= 5 {
            return RaceInformation(races: Array(raceSummaries?.prefix(5) ?? []))
        } else {
            return RaceInformation(races: Array(raceSummaries ?? []))
        }
    }

    init(racesDataRepository: RacesDataRepository) {
        self.racesDataRepository = racesDataRepository
    }
}

private extension Array<RaceSummaryModel> {
    func sortByStartTime() -> Self {
        self.sorted(by: { $0.advertisedStart < $1.advertisedStart })
    }

    func removeOldRaces() -> Self {
        self.filter {
            guard let raceTime = $0.advertisedStart.raceDateTime else { return false }
            return raceTime.timeIntervalSinceNow > -59
        }
    }

    func filter(for category: RaceCategoryTypeModel) -> Self {
        if category == .all {
            return self
        } else {
            return self.filter { $0.category == category }
        }
    }
}
