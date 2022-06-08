//
//  ApolloManager.swift
//  DSNP-Wallet
//
//  Created by Ryan Sheh on 6/3/22.
//

import Foundation
import Apollo
import ApolloWebSocket

class ApolloManager: ApolloClientProtocol {
    
    static let shared = ApolloManager()
    public var environment: GraphQLEnvironment
    
    init() {
    self
            .environment = .dev
    }
    
    private(set) lazy var client: ApolloClient = {
        let client = URLSessionClient()
        let cache = InMemoryNormalizedCache()
        let store = ApolloStore(cache: cache)
        let provider = DefaultInterceptorProvider(store: store)
        let url = environment.clientUrl
        var request = URLRequest(url: url)
        let transport = RequestChainNetworkTransport(
            interceptorProvider: provider,
            endpointURL: url
        )
        
        return ApolloClient(networkTransport: transport, store: store)
    }()
}

