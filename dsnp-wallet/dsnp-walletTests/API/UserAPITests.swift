//
//  DSNP-WalletTests.swift
//  DSNP-WalletTests
//
//  Created by Ryan Sheh on 4/26/22.
//

import XCTest
@testable import DSNP_Wallet
import Mocker

class UserAPITests: XCTestCase {

    override func setUp() {
        super.setUp()
        UserAPI.shared.client = MockApolloClient.shared
        AccountKeychain.shared.clearAuthorization()
        Mocker.removeAll()
    }
    
    func testAPILogin() {
        let expectation = self.expectation(description: "")

        let url = MockApolloClient.shared.getUrlWithMethod("")
        let mock = Mock(url: url, dataType: .json, statusCode: 200, data: [
            .post: MockedData.loginNonce.data
        ])
        mock.register()

        waitForExpectations(timeout: 1.0, handler: nil)
    }
}
