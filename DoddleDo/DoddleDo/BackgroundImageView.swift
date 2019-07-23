//
//  BackgroundImageView.swift
//  DoddleDo
//
//  Created by Xuzh on 2019/7/23.
//  Copyright © 2019 Xuzh. All rights reserved.
//

import UIKit

class BackgroundImageView: UIView {

    override func draw(_ rect: CGRect) {
        if let mainBackground = UIImage(named: "MainBackground", in: Bundle(for: self.classForCoder), compatibleWith: traitCollection){
            mainBackground.draw(in: bounds)
        }
    }

    
}
