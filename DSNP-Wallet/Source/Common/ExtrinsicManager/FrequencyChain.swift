//
//  FrequencyChain.swift
//  DSNP-Wallet
//
//  Created by Ryan Sheh on 2/22/23.
//

import Foundation
import RobinHood
import BigInt

enum Currency: BigUInt {
    case dollar = 100000000 //one token = 100000000 units
    case cent = 1000000
    case millicent = 1000
    case unit = 1
}

struct FrequencyChain {
    static let shared = FrequencyChain()
    let id = "496e2f8a93bf4576317f998d01480f9068014b368856ec088a63e57071cd1d49"
    let chainShortName = "Freq"
    let chainName = "Frequency"
    let prefixValue: UInt16 = 42
    let polkadotSettingsUrl = "https://raw.githubusercontent.com/nova-wallet/nova-utils/master/chains/v2/types/polkadot.json"
    let nodeUrl = "ws://127.0.0.1:9944"
    let cryptoType: MultiassetCryptoType = .sr25519
    
    func getChainModel() -> ChainModel {
        let typesSettingsUrl = URL(string: polkadotSettingsUrl)!
        let typesSettings = ChainModel.TypesSettings(
            url: typesSettingsUrl,
            overridesCommon: true
        )

        let asset = AssetModel(
            assetId: 0,
            icon: nil,
            name: chainName,
            symbol: chainName,
            precision: prefixValue,
            priceId: nil,
            staking: nil,
            type: nil,
            typeExtras: nil,
            buyProviders: nil
        )

        let localNodeString = nodeUrl
        let localNodeUrl = URL(string: localNodeString)
        let chainNodeModel = ChainNodeModel(
            url: localNodeUrl!,
            name: "Local Node",
            apikey: nil,
            order: 0
        )
        return ChainModel(
            chainId: id,
            parentId: nil,
            name: chainName,
            assets: [asset],
            nodes: [chainNodeModel],
            addressPrefix: prefixValue,
            types: typesSettings,
            icon: URL(string: "www.google.com")!,
            color: nil,
            options: nil,
            externalApi: nil,
            explorers: nil,
            order: 0,
            additional: nil
        )
    }
    
    func getFreqChainChange() -> DataProviderChange<ChainModel> {
        let frequencyChange = DataProviderChange<ChainModel>.insert(newItem: getChainModel())
        return frequencyChange
    }
}
