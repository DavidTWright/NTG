//
//  RacesDataEndpoint.swift
//  EntainTechTest
//
//  Created by David Wright on 25/4/2025.
//

import Foundation

struct RacesDataEndpoint: EndPoint, Sendable {
    struct Body: Encodable {}
    let body: Body? = nil
    var header: [String: String]?

    typealias SuccessResponse = RacesDataResponse
    typealias FailureResponse = NetworkError

    var host: String = "api.neds.com.au"
    var path: String = "/rest/v1/racing/"
    var queryItems: [String: String?]? { ["method": "nextraces", "count": "\(fetchRaceCount)"] }
    var requestMethod: RequestMethod = .get
    var timeOutInterval: TimeInterval { 60 }
    var successDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }

    private(set) var fetchRaceCount: Int

    init(with fetchRaceCount: Int = 10) { self.fetchRaceCount = fetchRaceCount}

    mutating func increaseFetchCount() { self.fetchRaceCount += 10 }
    mutating func resetFetchCount() { self.fetchRaceCount = 10 }
}
