//
//  String+Localizable.swift
//  EntainTechTest
//
//  Created by David Wright on 26/4/2025.
//

import Foundation

extension String {
    func localized() -> String {
        Bundle.appBundle.localizedString(forKey: self, value: nil, table: "Localization")
    }
}
