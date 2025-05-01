//
//  RacesDataResponse.swift
//  EntainTechTest
//
//  Created by David Wright on 25/4/2025.
//

import Foundation

struct RacesDataResponse: Codable {
    let status: Int
    let racesData: RaceDataResponse
    let message: String

    private enum CodingKeys: String, CodingKey {
        case status
        case racesData = "data"
        case message
    }
}

struct RaceDataResponse: Codable {
    let nextToGoIds: Set<String>
    let raceSummaries: [String: RaceSummaryResponse]
}

struct RaceSummaryResponse: Codable {
    let raceId: String
    let raceName: String
    let raceNumber: Int
    let meetingId: String
    let meetingName: String
    let advertisedStart: RaceTimeResponse
    let categoryId: String
    let raceForm: RaceFormResponse
    let venueId: String
    let venueName: String
    let venueState: String
    let venueCountry: String
}

struct RaceTimeResponse: Codable {
    let raceDateTime: Date?

    enum CodingKeys: String, CodingKey {
        case raceDateTime = "seconds"
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let unixTime = try container.decode(TimeInterval.self, forKey: .raceDateTime)
        self.raceDateTime = Date(timeIntervalSince1970: unixTime)
    }
}

struct RaceFormResponse: Codable {
    let distance: Int
    let distanceType: DistanceTypeResponse
    let distanceTypeId: String
    let trackCondition: TrackConditionResponse?
    let trackConditionId: String?
    let weather: RaceWeatherResponse?
    let weatherId: String?
    let raceComment: String?
    // Significant amounts of parsing invovled for this property, skipping...
    let additionalData: String
    let generated: Int
    let silkBaseUrl: String
    let raceCommentAlternative: String?

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.distance = try container.decode(Int.self, forKey: .distance)
        self.distanceType = try container.decode(DistanceTypeResponse.self, forKey: .distanceType)
        self.distanceTypeId = try container.decode(String.self, forKey: .distanceTypeId)
        self.trackCondition = try container.decodeIfPresent(TrackConditionResponse.self, forKey: .trackCondition)
        self.trackConditionId = try container.decodeIfPresent(String.self, forKey: .trackConditionId)
        self.weather = try container.decodeIfPresent(RaceWeatherResponse.self, forKey: .weather)
        self.weatherId = try container.decodeIfPresent(String.self, forKey: .weatherId)
        self.raceComment = try container.decodeIfPresent(String.self, forKey: .raceComment)
        self.additionalData = try container.decode(String.self, forKey: .additionalData)
        self.generated = try container.decode(Int.self, forKey: .generated)
        self.silkBaseUrl = try container.decode(String.self, forKey: .silkBaseUrl)
        self.raceCommentAlternative = try container.decodeIfPresent(String.self, forKey: .raceCommentAlternative)
    }
}

struct DistanceTypeResponse: Codable {
    let id: String
    let name: String
    let shortName: String
}

struct TrackConditionResponse: Codable {
    let id: String
    let name: String
    let shortName: String
}

struct RaceWeatherResponse: Codable {
    let id: String?
    let name: String?
    let shortName: String?
    let iconUri: String?
}
