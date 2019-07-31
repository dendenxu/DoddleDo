//
//  BackgroundImageView.swift
//  DoddleDo
//
//  Created by Xuzh on 2019/7/23.
//  Copyright © 2019 Xuzh. All rights reserved.
//

import UIKit

//@IBDesignable
class MainSceneBackgroundLayoutView: UIView {

    
    override func layoutSubviews() {
        nameImageView.frame = CGRect(x: 64, y: 52, width: 384, height: 89)
        
        bottomLine.frame.size = CGSize.zero
        bottomLine.sizeToFit()
        bottomLine.center = CGPoint(x: 342, y: 354)
    }
    

}

