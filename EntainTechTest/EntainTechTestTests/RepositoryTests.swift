//
//  RepositoryTests.swift
//  EntainTechTestTests
//
//  Created by David Wright on 25/4/2025.
//

@testable import EntainTechTest
import Foundation
import Testing

struct RepositoryTests {
    struct RacesDataRepositoryImplTests {
        var decoder: JSONDecoder {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return decoder
        }

        // Wow, there is some terrible console/run-time behaviour for json decoding failures when using #require!
        func networkingMock() throws -> Networking {
            let url = try #require(Bundle.testBundle.url(forResource: "races_data_response", withExtension: "json"))
            let data = try #require(try? Data(contentsOf: url))
            let response = try #require(try? decoder.decode(RacesDataEndpoint.SuccessResponse.self, from: data))
            return NetworkingMock(response: response)
        }

        @Test func testFetchRacesData() async throws {
            let repository = RacesDataRepositoryImpl(
                raceDataEndpoint: RacesDataEndpoint(),
                networking: try #require(try? networkingMock()),
                responseMapper: ResponseMapper()
            )
            let racesDataModel = try #require(try? await repository.fetchRaceData(resetFetchCount: true))
            #expect(racesDataModel.racesData.raceSummaries.count == 10)
        }
    }
}
