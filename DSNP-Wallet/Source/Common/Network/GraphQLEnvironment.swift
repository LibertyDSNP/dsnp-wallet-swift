//
//  GraphQLEnvironment.swift
//  DSNP-Wallet
//
//  Created by Ryan Sheh on 6/3/22.
//

import Foundation

enum GraphQLEnvironment {
    case dev
    
    private var domainName: String {
        get {
            switch self {
            case .dev:
                return ""
            }
        }
    }
    
    public var clientUrl: URL {
        return URL(string: "https://\(self.domainName)")!
    }
}
