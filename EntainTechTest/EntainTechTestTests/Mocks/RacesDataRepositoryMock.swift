//
//  RacesDataRepositoryMock.swift
//  EntainTechTestTests
//
//  Created by David Wright on 1/5/2025.
//

@testable import EntainTechTest
import Testing

final actor RacesDataRepositoryMock: RacesDataRepository {
    func fetchRaceData(resetFetchCount: Bool) async throws -> RacesDataModel? {
        return RacesDataModelMock().mock
    }
    
    func fethMoreRaceData() async throws -> RacesDataModel? {
        return RacesDataModelMock().mock
    }
}
