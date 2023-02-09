import Foundation
import SubstrateSdk
import IrohaCrypto
import BigInt

protocol SubstrateCallFactoryProtocol {
    func nativeTransfer(
        to receiver: AccountId,
        amount: BigUInt
    ) -> RuntimeCall<TransferCall>

    func assetsTransfer(
        to receiver: AccountId,
        assetId: String,
        amount: BigUInt
    ) -> RuntimeCall<AssetsTransfer>

    func ormlTransfer(
        in moduleName: String,
        currencyId: JSON,
        receiverId: AccountId,
        amount: BigUInt
    ) -> RuntimeCall<OrmlTokenTransfer>
    
    func chill() -> RuntimeCall<NoRuntimeArgs>
}

final class SubstrateCallFactory: SubstrateCallFactoryProtocol {

    func assetsTransfer(
        to receiver: AccountId,
        assetId: String,
        amount: BigUInt
    ) -> RuntimeCall<AssetsTransfer> {
        let args = AssetsTransfer(assetId: assetId, target: .accoundId(receiver), amount: amount)
        return RuntimeCall(moduleName: "Assets", callName: "transfer", args: args)
    }

    func nativeTransfer(
        to receiver: AccountId,
        amount: BigUInt
    ) -> RuntimeCall<TransferCall> {
        let args = TransferCall(dest: .accoundId(receiver), value: amount)
        return RuntimeCall(moduleName: "Balances", callName: "transfer", args: args)
    }

    func ormlTransfer(
        in moduleName: String,
        currencyId: JSON,
        receiverId: AccountId,
        amount: BigUInt
    ) -> RuntimeCall<OrmlTokenTransfer> {
        let args = OrmlTokenTransfer(
            dest: .accoundId(receiverId),
            currencyId: currencyId,
            amount: amount
        )

        return RuntimeCall(moduleName: moduleName, callName: "transfer", args: args)
    }

    func chill() -> RuntimeCall<NoRuntimeArgs> {
        RuntimeCall(moduleName: "Staking", callName: "chill")
    }
}
