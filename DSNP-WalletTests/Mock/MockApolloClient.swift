//
//  MockApolloClient.swift
//  DSNP-WalletTests
//
//  Created by Ryan Sheh on 6/7/22.
//

import XCTest
@testable import DSNP_Wallet
import Apollo
import Mocker

class MockApolloClient: DSNPWalletApolloClientProtocol {
    
    static let shared = MockApolloClient()

    private var baseUrl = GraphQLEnvironment.dev.clientUrl

    private(set) lazy var client: ApolloClient = {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockingURLProtocol.self]
        let client = URLSessionClient(sessionConfiguration: configuration)
        let cache = InMemoryNormalizedCache()
        let store = ApolloStore(cache: cache)
        let provider = DefaultInterceptorProvider(store: store)
        let url = self.baseUrl
        var request = URLRequest(url: url)
        let transport = RequestChainNetworkTransport(interceptorProvider: provider, endpointURL: url)
        return ApolloClient(networkTransport: transport, store: store)
    }()

    public func getUrlWithMethod(_ method: String) -> URL? {
        return URL(string: method)
    }
}
