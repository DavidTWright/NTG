//
//  RaceInformation.swift
//  EntainTechTest
//
//  Created by David Wright on 25/4/2025.
//

import Foundation

struct RaceInformation {
    var races: [RaceSummaryModel]

    init(races: [RaceSummaryModel]?) {
        self.races = races ?? []
    }
}
