//
//  MockedData.swift
//  DSNP-WalletTests
//
//  Created by Ryan Sheh on 6/7/22.
//

import XCTest
@testable import DSNP_Wallet
import Mocker

public final class MockedData {
    public static let login: URL = MockedData.url(resource: "Login")
    
    private static func url(resource: String) -> URL {
        return Bundle(for: MockedData.self).url(forResource: resource, withExtension: "json")!
    }
}

internal extension URL {
    // Returns a `Data` representation of the current `URL`. Force unwrapping as it's only used for tests.
    var data: Data {
        return try! Data(contentsOf: self)
    }
}
