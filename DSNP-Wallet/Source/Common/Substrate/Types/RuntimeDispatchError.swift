//
//  RuntimeDispatchError.swift
//  DSNP-Wallet
//
//  Created by Ryan Sheh on 5/30/23.
//

import Foundation
import SubstrateSdk
import BigInt

enum DecodingDispatchError: Error {
    case badConversion
}

struct RuntimeDispatchError: Decodable {
    private let array: [JSON]
    let index: UInt8?
    let error: UInt8?

    //We get error index in little endian, hexademical.
    //Review: Big Endian -> |12| |34| |56| |78|, Little Endian |78| |56| |34| |12|
    //e.g.:
    // index 2 -> hex is 0002 (4 bytes) -> ["2", "0", "0", "0"]
    // index 17 -> hex is 11 -> ["11", "0", "0", "0"]
    init(from decoder: Decoder) throws {
        var unkeyedContainer = try decoder.unkeyedContainer()
        array = try unkeyedContainer.decode([JSON].self)

        let errorDict = array.last?.dictValue as? [String: JSON] //.last bc .first of DispatchError is just string "Module"
        index = UInt8(errorDict?["index"]?.stringValue ?? "")

        let errorIndices = errorDict?["error"]?.arrayValue as? [JSON] ?? []
        let errorArray: [String] = try errorIndices.compactMap { jsonVal in
            guard let indexStringVal = jsonVal.stringValue else { throw DecodingDispatchError.badConversion }
            return indexStringVal.count == 1 ? "0" + indexStringVal : indexStringVal
        }
        let errorString = errorArray.joined(separator: "")
        let byteArray = try Data(hexString: errorString)
        let errorIndex = byteArray.withUnsafeBytes { $0.load(as: UInt16.self) }

        error = UInt8(errorIndex)
    }
}

