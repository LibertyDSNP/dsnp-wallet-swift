/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/


import Foundation
import SoraUI

final class QRView: UIView {
    @IBOutlet private(set) var borderedView: BorderedContainerView!
    @IBOutlet private(set) var imageView: UIImageView!
    @IBOutlet private(set) var qrBorderView: RoundedView!
    @IBOutlet private var top: NSLayoutConstraint!
    @IBOutlet private var bottom: NSLayoutConstraint!

    @IBOutlet private var borderTop: NSLayoutConstraint!
    @IBOutlet private var borderBottom: NSLayoutConstraint!
    @IBOutlet private var borderLeading: NSLayoutConstraint!
    @IBOutlet private var borderTrailing: NSLayoutConstraint!

    var borderWidth: CGFloat {
        get {
            borderTrailing.constant
        }

        set {
            borderTop.constant = -newValue
            borderLeading.constant = -newValue
            borderTrailing.constant = newValue
            borderBottom.constant = newValue
        }
    }

    var margin: CGFloat {
        get {
            top.constant
        }

        set {
            top.constant = newValue
            bottom.constant = -newValue

            if superview != nil {
                setNeedsLayout()
            }
        }
    }
}
