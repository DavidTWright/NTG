//
//  Bundle+Tests.swift
//  EntainTechTestTests
//
//  Created by David Wright on 26/4/2025.
//

import Foundation

extension Bundle {
    static var appBundle: Bundle {
        Bundle(for: TestClass.self)
    }
}

private class TestClass {}
