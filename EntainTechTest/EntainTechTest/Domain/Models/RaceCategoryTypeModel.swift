//
//  RaceCategoryTypeModel.swift
//  EntainTechTest
//
//  Created by David Wright on 26/4/2025.
//

import Foundation

enum RaceCategoryTypeModel: String, CaseIterable, CustomStringConvertible, Identifiable, Equatable {
    case horse = "4a2788f8-e825-4d36-9894-efd4baf1cfae"
    case greyhound = "9daef0d7-bf3c-4f50-921d-8e818c60fe61"
    case harness = "161d9be2-e909-4326-8c2c-35ed71fb460b"
    case all = "all"

    var iconName: String {
        switch self {
        case .all: return "a.circle"
        case .horse: return "h.circle"
        case .greyhound: return "g.circle"
        case .harness: return "t.circle"
        }
    }

    var description: String {
        switch self {
        case .all: return "all"
        case .horse: return "horse"
        case .greyhound: return "greyhound"
        case .harness: return "harness"
        }
    }

    var id: String { self.rawValue }
}
