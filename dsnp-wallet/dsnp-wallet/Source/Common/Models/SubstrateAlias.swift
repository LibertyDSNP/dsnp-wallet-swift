import Foundation

typealias AccountAddress = String
typealias AccountId = Data
typealias BlockNumber = UInt32
typealias Moment = UInt32

struct SubstrateConstants {
    static let accountIdLength = 32
}

extension AccountId {
    static func matchHex(_ value: String) -> AccountId? {
        guard let data = try? Data(hexString: value) else {
            return nil
        }

        return data.count == SubstrateConstants.accountIdLength ? data : nil
    }
}

extension BlockNumber {
    func secondsTo(block: BlockNumber, blockDuration: UInt64) -> TimeInterval {
        let durationInSeconds = TimeInterval(blockDuration).seconds
        let diffBlock = TimeInterval(Int(block) - Int(self))
        let seconds = diffBlock * durationInSeconds
        return seconds
    }

    func toHex() -> String {
        var blockNumber = self

        return Data(
            Data(bytes: &blockNumber, count: MemoryLayout<UInt32>.size).reversed()
        ).toHex(includePrefix: true)
    }
}

extension AccountAddress {
    var truncated: String {
        guard count > 9 else {
            return self
        }

        let prefix = self.prefix(4)
        let suffix = self.suffix(5)

        return "\(prefix)...\(suffix)"
    }
}
