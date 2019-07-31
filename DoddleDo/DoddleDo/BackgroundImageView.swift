//
//  BackgroundView.swift
//  DoddleDo
//
//  Created by Xuzh on 2019/7/28.
//  Copyright © 2019 Xuzh. All rights reserved.
//

import UIKit


@IBDesignable
class BackgroundImageView: UIView {

    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: 40)
        path.addClip()
        if let image = UIImage(named: "mainBackground", in: Bundle(for: classForCoder), compatibleWith: traitCollection) {
            image.draw(in: bounds)
        }
    }
    override func awakeFromNib() {
        bounds = UIScreen.main.bounds
        backgroundColor = UIColor.clear
    }

}
