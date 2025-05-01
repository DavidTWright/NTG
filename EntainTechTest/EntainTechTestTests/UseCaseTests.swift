//
//  UseCaseTests.swift
//  EntainTechTestTests
//
//  Created by David Wright on 1/5/2025.
//

@testable import EntainTechTest
import Testing

struct UseCaseTests {
    @Test func getRacesDateUseCaseImpl() async throws {
        let useCase = GetRacesDataUseCaseImpl(racesDataRepository: RacesDataRepositoryMock())
        let model = #require(try await useCase.invoke(with: .all))
        #expect(model.races.count == 0)
        
    }
}
