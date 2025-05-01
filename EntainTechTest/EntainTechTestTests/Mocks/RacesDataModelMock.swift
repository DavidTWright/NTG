//
//  RacesDataModelMock.swift
//  EntainTechTestTests
//
//  Created by David Wright on 1/5/2025.
//

@testable import EntainTechTest
import Foundation

struct RacesDataModelMock {
    var mock: RacesDataModel {
        let responseMapper = ResponseMapper()
        let filePath = Bundle.testBundle.url(forResource: "races_data_response", withExtension: "json")!
        let data = try! Data(contentsOf: filePath)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let response = try! decoder.decode(RacesDataResponse.self, from: data)
        return responseMapper.mapResponseToDomain(response)
    }
}
