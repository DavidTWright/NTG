//
//  Networking.swift
//  EntainTechTest
//
//  Created by David Wright on 25/4/2025.
//

import Foundation

public protocol Networking: Sendable {
    func fetch<T: EndPoint>(with endpoint: T) async throws -> Result<T.SuccessResponse, T.FailureResponse>
}

public final class NetworkingImpl: Networking {
    private let session: URLSession

    // In production there would be about 4-5  of these functions
    // that can cater for all kinds of req/res processing and decoding
    public func fetch<T: EndPoint>(with endpoint: T) async throws -> Result<T.SuccessResponse, T.FailureResponse> {
        guard let request = try? endpoint.request() else { throw NetworkError() }

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw NetworkError()
            }
            let responseObject = try endpoint.successDecoder.decode(T.SuccessResponse.self, from: data)
            return .success(responseObject)
        } catch let decodingError {
            throw NetworkError(localizedDesciption: decodingError.localizedDescription)
        }
    }

    init() {
        session = URLSession(configuration: URLSessionConfiguration.ephemeral)
    }
}

struct NetworkError: Error, Decodable {
    var localizedDesciption = "Network go boom"
}
