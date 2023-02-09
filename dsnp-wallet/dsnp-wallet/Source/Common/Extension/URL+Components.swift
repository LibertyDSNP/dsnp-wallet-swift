//
//  URL+Components.swift
//  dsnp-wallet
//
//  Created by Ryan Sheh on 6/22/22.
//

import Foundation

extension URL {
    var components: URLComponents? {
        return URLComponents(url: self, resolvingAgainstBaseURL: false)
    }
}

extension URLComponents {
    subscript(_ param: String) -> String? {
        return self.queryItems?.first(where: { $0.name == param })?.value
    }
}
