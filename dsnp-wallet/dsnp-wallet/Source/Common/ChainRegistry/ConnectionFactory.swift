import Foundation
import SubstrateSdk

protocol ConnectionFactoryProtocol {
    func createConnection(delegate: WebSocketEngineDelegate?) throws -> ChainConnection
    func updateConnection(_ connection: ChainConnection, chain: ChainModel)
}

final class ConnectionFactory {
    let logger: SDKLoggerProtocol

    init(logger: SDKLoggerProtocol) {
        self.logger = logger
    }
}

extension ConnectionFactory: ConnectionFactoryProtocol {
    func createConnection(delegate: WebSocketEngineDelegate?) throws -> ChainConnection {
//        let url = URL(string: "wss://rpc.polkadot.io")!
//        let url = URL(string: "wss://kusama-rpc.polkadot.io")!
        let url = URL(string: "ws://127.0.0.1:9944")!
        let urls = [url]

        guard let connection = WebSocketEngine(urls: urls, name: nil, logger: logger) else {
            throw JSONRPCEngineError.unknownError
        }

        connection.delegate = delegate
        return connection
    }

    func updateConnection(_ connection: ChainConnection, chain: ChainModel) {
//        let newUrls = extractNodeUrls(from: chain)

//        if connection.urls != newUrls {
//            connection.changeUrls(newUrls)
//        }
    }

//    private func extractNodeUrls(from chain: ChainModel) -> [URL] {
//        chain.nodes.sorted(by: { $0.order < $1.order }).map(\.url)
//    }
}
