//
//  NetworkingMock.swift
//  EntainTechTestTests
//
//  Created by David Wright on 26/4/2025.
//

@testable import EntainTechTest
import Foundation

struct NetworkingMock: Networking {
    let response: RacesDataResponse
    let error: NetworkError? = nil

    func fetch<T>(with _: T) async throws -> Result<T.SuccessResponse, T.FailureResponse> where T: EndPoint {
        guard error == nil else {
            return .failure(error as! T.FailureResponse)
        }
        return .success(response as! T.SuccessResponse)
    }
}
