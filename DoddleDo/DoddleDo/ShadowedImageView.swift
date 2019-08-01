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
        layer.shadowOffset = CGSize(width: 4.0, height: 4.0)
        layer.shadowOpacity = 0.9
        layer.shadowRadius = 4.0
        clipsToBounds = false
        contentMode = .scaleToFill
    }
    
}
