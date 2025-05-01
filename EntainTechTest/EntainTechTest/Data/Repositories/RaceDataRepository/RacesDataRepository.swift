//
//  RacesDataRepository.swift
//  EntainTechTest
//
//  Created by David Wright on 25/4/2025.
//

import Foundation

protocol RacesDataRepository: Sendable {
    func fetchRaceData(resetFetchCount: Bool) async throws -> RacesDataModel?
    func fethMoreRaceData() async throws -> RacesDataModel?
}

actor RacesDataRepositoryImpl: RacesDataRepository {
    private var raceDataEndpoint: RacesDataEndpoint
    private let networking: Networking
    private let responseMapper: ResponseMapper

    func fetchRaceData(resetFetchCount: Bool) async throws -> RacesDataModel? {
        if resetFetchCount { raceDataEndpoint.resetFetchCount() }
        guard case let .success(response) = try? await networking.fetch(with: raceDataEndpoint) else {
            return nil
        }
        return responseMapper.mapResponseToDomain(response)
    }

    func fethMoreRaceData() async throws -> RacesDataModel? {
        raceDataEndpoint.increaseFetchCount()
        return try await fetchRaceData(resetFetchCount: false)
    }

    init(raceDataEndpoint: RacesDataEndpoint, networking: Networking, responseMapper: ResponseMapper) {
        self.raceDataEndpoint = raceDataEndpoint
        self.networking = networking
        self.responseMapper = responseMapper
    }
}
