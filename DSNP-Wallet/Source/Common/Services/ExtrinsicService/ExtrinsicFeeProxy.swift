import Foundation

typealias ExtrinsicFeeId = String

protocol ExtrinsicFeeProxyDelegate: AnyObject {
    func didReceiveFee(result: Result<RuntimeDispatchInfo, Error>, for identifier: ExtrinsicFeeId)
}

protocol ExtrinsicFeeProxyProtocol: AnyObject {
    var delegate: ExtrinsicFeeProxyDelegate? { get set }

    func estimateFee(
        using service: ExtrinsicServiceProtocol,
        reuseIdentifier: ExtrinsicFeeId,
        setupBy closure: @escaping ExtrinsicBuilderClosure
    )
}
