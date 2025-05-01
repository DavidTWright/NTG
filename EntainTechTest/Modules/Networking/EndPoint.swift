//
//  Endpoint.swift
//  EntainTechTest
//
//  Created by David Wright on 25/4/2025.
//

import Foundation

public protocol EndPoint: Sendable {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var queryItems: [String: String?]? { get }
    var requestMethod: RequestMethod { get }
    var header: [String: String]? { get }
    var body: Body? { get }
    var encoder: JSONEncoder { get }
    var successCodes: Set<Int> { get }
    var successDecoder: JSONDecoder { get }
    var maxRetries: Int { get }
    var timeout: TimeInterval { get }
    var contentType: String { get }

    associatedtype Body: Encodable
    associatedtype SuccessResponse: Decodable, Sendable
    associatedtype FailureResponse: Decodable, Error, Sendable
}

public extension EndPoint {
    var scheme: String { "https" }
    var encoder: JSONEncoder { .init() }
    var successCodes: Set<Int> { [200] }
    var successDecoder: JSONDecoder { JSONDecoder() }
    var maxRetries: Int { 1 }
    var timeout: TimeInterval { 60 }
    var contentType: String { "application/json charset=utf-8" }

    func urlComponents() -> URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        if let queryItems = queryItems {
            urlComponents.percentEncodedQueryItems = queryItems.map {
                URLQueryItem(name: $0.key, value: $0.value)
            }
        }
        return urlComponents
    }

    func request() throws -> URLRequest? {
        guard let url = urlComponents().url else {  return nil }
        var request = URLRequest(url: url)
        request.httpMethod = requestMethod.rawValue
        request.timeoutInterval = timeout
        request.allHTTPHeaderFields = header
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        request.setValue("/AppleApp/app/iOS", forHTTPHeaderField: "Referer")
        if let body = body {
            request.httpBody = try encoder.encode(body)
        }
        return request
    }
}

public enum RequestMethod: String, Sendable {
    case get = "GET"
    // ...
}
