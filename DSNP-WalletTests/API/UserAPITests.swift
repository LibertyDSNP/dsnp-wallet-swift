//
//  DSNP-WalletTests.swift
//  DSNP-WalletTests
//
//  Created by Ryan Sheh on 4/26/22.
//

import XCTest
@testable import DSNP_Wallet
import Mocker
import DSNPWallet

class UserAPITests: XCTestCase {
    
    var urlSession: URLSession!

    override func setUp() {
        super.setUp()
        Mocker.removeAll()
        setURLSession()
    }
    
    private func setURLSession() {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockingURLProtocol.self]
        urlSession = URLSession(configuration: configuration)
    }
    
    func testAPILogin() {
        let originalURL = MockedData.login
        let mock = Mock(url: originalURL, dataType: .json, statusCode: 200, data: [
            .get : try! Data(contentsOf: originalURL)
        ])
        mock.register()
        
        URLSession.shared.dataTask(with: originalURL) { (data, response, error) in
            guard let data = data,
                  let jsonDict = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any],
                  let dict = jsonDict["data"] as? [String: Int] else { return }
            
            XCTAssertEqual(dict["success"], 1)
            
        }.resume()
    }
}
