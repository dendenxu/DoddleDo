//
//  ScrollingImageView.swift
//  DoddleDo
//
//  Created by Xuzh on 2019/8/1.
//  Copyright © 2019 Xuzh. All rights reserved.
//

import UIKit

@IBDesignable
class ScrollingImageView: UIView {
    @IBInspectable
    var identifier: String!
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: 15)
        path.addClip()
        if let image = UIImage(named: identifier, in: Bundle(for: classForCoder), compatibleWith: traitCollection) {
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
        layer.shadowOffset = CGSize(width: 15.0, height: 15.0)
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 7.0
        clipsToBounds = false
        contentMode = .scaleToFill
    }

}
