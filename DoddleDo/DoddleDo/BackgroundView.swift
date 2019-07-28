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

    override func draw(_ rect: CGRect) {
        bounds = UIScreen.main.bounds
        drawBlack()
        clipInRoundedRect()
        if let image = UIImage(named: "mainBackground", in: Bundle(for: classForCoder), compatibleWith: traitCollection) {
            image.draw(in: bounds)
        }
    }

}

extension UIView {
    func drawBlack() {
        let path = UIBezierPath(rect: bounds)
        UIColor.black.setFill()
        path.fill()
    }
    
    func clipInRoundedRect() {
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: 40)
        path.addClip()
    }
}
