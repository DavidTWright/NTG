//
//  RacesDataModel.swift
//  EntainTechTest
//
//  Created by David Wright on 25/4/2025.
//

import Foundation

struct RacesDataModel {
    let status: Int
    let racesData: RaceDataModel
    let message: String
}

struct RaceDataModel {
    let nextToGoIds: Set<String>
    let raceSummaries: [RaceSummaryModel]
}

struct RaceSummaryModel {
    let raceId: String
    let raceName: String
    let raceNumber: Int
    let meetingId: String
    let meetingName: String
    let advertisedStart: RaceTimeModel
    let category: RaceCategoryTypeModel
    let raceForm: RaceFormModel
    let venueId: String
    let venueName: String
    let venueState: String
    let venueCountry: String
}

struct RaceTimeModel: Comparable {
    let raceDateTime: Date?

    static func < (lhs: RaceTimeModel, rhs: RaceTimeModel) -> Bool {
        guard let firstDate = lhs.raceDateTime, let secondDate = rhs.raceDateTime else { return false }
        return firstDate < secondDate
    }
}

struct RaceFormModel {
    let distance: Int
    let distanceType: DistanceTypeModel
    let distanceTypeId: String
    let trackCondition: TrackConditionModel?
    let trackConditionId: String?
    let weather: RaceWeatherModel?
    let weatherId: String?
    let raceComment: String?
    // Significant amounts of parsing invovled for this property, skipping...
    let additionalData: String
    let generated: Int
    let silkBaseUrl: String
    let raceCommentAlternative: String?
}

struct DistanceTypeModel {
    let id: String
    let name: String
    let shortName: String
}

struct TrackConditionModel {
    let id: String?
    let name: String?
    let shortName: String?
}

struct RaceWeatherModel {
    let id: String?
    let name: String?
    let shortName: String?
    let iconUri: String?
}
