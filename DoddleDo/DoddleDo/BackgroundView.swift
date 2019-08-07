//
//  BackgroundView.swift
//  DoddleDo
//
//  Created by Xuzh on 2019/7/28.
//  Copyright © 2019 Xuzh. All rights reserved.
//

import UIKit

@IBDesignable
class BackgroundView: UIView {

    @IBInspectable
    var identifier: String?

    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: constants.cornerRadius)
        path.addClip()
        if let id = identifier, let image = UIImage(named: id, in: Bundle(for: classForCoder), compatibleWith: traitCollection) {
            image.draw(in: bounds)
        }
    }

    override func awakeFromNib() {
        backgroundColor = UIColor.clear
    }

}

extension BackgroundView {
    private struct constants {
        static let cornerRadius:CGFloat = 20
    }
}
