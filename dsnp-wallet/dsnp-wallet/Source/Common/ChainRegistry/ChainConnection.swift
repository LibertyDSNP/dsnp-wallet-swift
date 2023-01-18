import Foundation
import SubstrateSdk

protocol ChainConnection: JSONRPCEngine & ConnectionAutobalancing & ConnectionStateReporting {
    func connect()
    func disconnect(_ force: Bool)
}

extension WebSocketEngine: ChainConnection {
    func connect() {
        connectIfNeeded()
    }

    func disconnect(_ force: Bool) {
        disconnectIfNeeded(force)
    }
}

protocol ConnectionAutobalancing {
    var urls: [URL] { get }

    func changeUrls(_ newUrls: [URL])
}

protocol ConnectionStateReporting {
    var state: WebSocketEngine.State { get }
}
