//
//  ScrollingImageView.swift
//  DoddleDo
//
//  Created by Xuzh on 2019/8/1.
//  Copyright © 2019 Xuzh. All rights reserved.
//

import UIKit

@IBDesignable
class ScrollingView: UIView {
    
    @IBInspectable
    var identifier: String?
    
    @IBInspectable
    var image: UIImage?
    
    @IBInspectable
    var cornerRadius: CGFloat = 15
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        path.addClip()
        if let image = image {
            image.draw(in: bounds)
        } else if let identifier = identifier, let image = UIImage(named: identifier, in: Bundle(for: classForCoder), compatibleWith: traitCollection) {
            image.draw(in: bounds)
        }
    }
    
    init(identifier: String, rect: CGRect) {
        super.init(frame: rect)
        self.identifier = identifier
        initializationWork()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializationWork()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializationWork()
    }
    private func initializationWork() {
        backgroundColor = UIColor.clear
        layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        layer.shadowOffset = CGSize(width: constants.shadowOffsetX, height: constants.shadowOffsetY)
        layer.shadowOpacity = constants.shadowOpacity
        layer.shadowRadius = constants.shadowRadius
        clipsToBounds = false
        contentMode = .scaleToFill
    }
}

extension ScrollingView {
    private struct constants {
        static let shadowOffsetX: CGFloat = 10
        static let shadowOffsetY: CGFloat = 10
        static let shadowOpacity: Float = 1
        static let shadowRadius: CGFloat = 6
    }
}
