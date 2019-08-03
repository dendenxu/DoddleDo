//
//  ShadowedImageView.swift
//  DoddleDo
//
//  Created by Xuzh on 2019/7/23.
//  Copyright © 2019 Xuzh. All rights reserved.
//

import UIKit


@IBDesignable
class ShadowedImageView: UIImageView {

    @IBInspectable
    var identifier: String?

    override init(frame: CGRect) {
        super.init(frame: frame)
        initializationWork()
    }
    override init(image: UIImage?) {
        super.init(image: image)
        initializationWork()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializationWork()
    }
    private func initializationWork() {
        layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        layer.shadowOffset = CGSize(width: constants.shadowOffsetX, height: constants.shadowOffsetY)
        layer.shadowOpacity = constants.shadowOpacity
        layer.shadowRadius = constants.shadowRadius
        clipsToBounds = false
        contentMode = .scaleToFill
    }
}

extension ShadowedImageView {
    private struct constants {
        static let shadowOffsetX: CGFloat = 4
        static let shadowOffsetY: CGFloat = 4
        static let shadowOpacity: Float = 0.9
        static let shadowRadius: CGFloat = 4
    }
}
