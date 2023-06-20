//
//  SeedManagerTests.swift
//  DSNP-WalletTests
//
//  Created by Ryan Sheh on 6/20/23.
//

import XCTest
@testable import DSNP_Wallet


class SeedManagerTest: XCTestCase {
    override func setUpWithError() throws {
        
    }
    
    override func tearDownWithError() throws {
        
    }
    
    func testGenerateCheckDerive() throws {
        let mnemonic = SeedManager.shared.generateMnemonic()
        XCTAssertNotNil(mnemonic)
        
        guard let mnemonic = mnemonic else {
            return XCTFail("Bad mnemonic")
        }
        let keyPair = SeedManager.shared.getKeypair(mnemonic: mnemonic)
        XCTAssertNotNil(keyPair)
    }
}
