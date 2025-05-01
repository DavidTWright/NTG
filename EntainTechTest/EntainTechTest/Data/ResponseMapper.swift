//
//  ResponseMapper.swift
//  EntainTechTest
//
//  Created by David Wright on 25/4/2025.
//

import Foundation

final class ResponseMapper: @unchecked Sendable {
    func mapResponseToDomain(_ response: RacesDataResponse) -> RacesDataModel {
        RacesDataModel(
            status: response.status,
            racesData: RaceDataModel(
                nextToGoIds: response.racesData.nextToGoIds,
                // Ignoring the id key for these dictionary's - its the same as the race_id
                // Im not in practice, deoding according to the BE interface
                // but id be asking why its done this way
                raceSummaries: response.racesData.raceSummaries.map { _, summary in
                    RaceSummaryModel(
                       raceId: summary.raceId,
                       raceName: summary.raceName,
                       raceNumber: summary.raceNumber,
                       meetingId: summary.meetingId,
                       meetingName: summary.meetingName,
                       advertisedStart: RaceTimeModel(raceDateTime: summary.advertisedStart.raceDateTime),
                       category: RaceCategoryTypeModel(rawValue: summary.categoryId) ?? .horse,
                       raceForm:
                           RaceFormModel(
                               distance: summary.raceForm.distance,
                               distanceType: DistanceTypeModel(
                                   id: summary.raceForm.distanceType.id,
                                   name: summary.raceForm.distanceType.name,
                                   shortName: summary.raceForm.distanceType.shortName
                               ),
                               distanceTypeId: summary.raceForm.distanceTypeId,
                               trackCondition:
                                   TrackConditionModel(
                                       id: summary.raceForm.trackCondition?.id,
                                       name: summary.raceForm.trackCondition?.name,
                                       shortName: summary.raceForm.trackCondition?.shortName
                                   ),
                               trackConditionId: summary.raceForm.trackConditionId,
                               weather: RaceWeatherModel(
                                   id: summary.raceForm.weather?.id,
                                   name: summary.raceForm.weather?.name,
                                   shortName: summary.raceForm.weather?.shortName,
                                   iconUri: summary.raceForm.weather?.iconUri
                               ),
                               weatherId: summary.raceForm.weatherId,
                               raceComment: summary.raceForm.raceComment,
                               additionalData: summary.raceForm.additionalData,
                               generated: summary.raceForm.generated,
                               silkBaseUrl: summary.raceForm.silkBaseUrl,
                               raceCommentAlternative: summary.raceForm.raceCommentAlternative
                           ),
                       venueId: summary.venueId,
                       venueName: summary.venueName,
                       venueState: summary.venueState,
                       venueCountry: summary.venueCountry
                   )
                }),
            message: response.message
            )
    }
}
