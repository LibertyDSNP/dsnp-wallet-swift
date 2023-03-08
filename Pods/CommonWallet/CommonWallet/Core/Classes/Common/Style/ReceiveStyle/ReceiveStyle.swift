/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation

public protocol ReceiveStyleProtocol {
    var qrBackgroundColor: UIColor { get }
    var qrMode: UIImageView.ContentMode { get }
    var qrSize: CGSize? { get }
    var qrMargin: CGFloat? { get }
    var qrBorderWidth: CGFloat { get }
    var qrBorderRadius: CGFloat { get }
}

public struct ReceiveStyle: ReceiveStyleProtocol {
    public let qrBackgroundColor: UIColor
    public let qrMode: UIImageView.ContentMode
    public let qrSize: CGSize?
    public let qrMargin: CGFloat?
    public let qrBorderWidth: CGFloat
    public let qrBorderRadius: CGFloat

    public init(qrBackgroundColor: UIColor,
                qrMode: UIImageView.ContentMode,
                qrSize: CGSize?,
                qrMargin: CGFloat?,
                qrBorderWidth: CGFloat = 0.0,
                qrBorderRadius: CGFloat = 0.0
    ) {
        self.qrBackgroundColor = qrBackgroundColor
        self.qrMode = qrMode
        self.qrSize = qrSize
        self.qrMargin = qrMargin
        self.qrBorderWidth = qrBorderWidth
        self.qrBorderRadius = qrBorderRadius
    }
}

extension ReceiveStyle {
    static func createDefaultStyle(with style: WalletStyleProtocol) -> ReceiveStyle {
        return ReceiveStyle(qrBackgroundColor: .white,
                            qrMode: .scaleAspectFit,
                            qrSize: nil,
                            qrMargin: nil)
    }
}
