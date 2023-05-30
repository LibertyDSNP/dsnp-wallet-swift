//
//  RuntimeDispatchError.swift
//  DSNP-Wallet
//
//  Created by Ryan Sheh on 5/30/23.
//

import Foundation
import SubstrateSdk
import BigInt

struct RuntimeDispatchError: Decodable {
    private let array: [JSON]
    let index: UInt8?
    let error: UInt8?
    
    init(from decoder: Decoder) throws {
        var unkeyedContainer = try decoder.unkeyedContainer()
        array = try unkeyedContainer.decode([JSON].self)
        
        let errorDict = array.last?.dictValue as? [String: JSON]
        index = UInt8(errorDict?["index"]?.stringValue ?? "")
        
        let errorIndices = errorDict?["error"]?.arrayValue as? [JSON] ?? []
        let errorArray: [String] = errorIndices.compactMap { return $0.stringValue }
        let hexString = errorArray.joined(separator: "")

        let byteArray = try Data(hexString: hexString) //e.g. convert 0x0400 into 4
        let errorIndex = byteArray.withUnsafeBytes { $0.load(as: UInt16.self) }
        error = UInt8(errorIndex )
    }
}

