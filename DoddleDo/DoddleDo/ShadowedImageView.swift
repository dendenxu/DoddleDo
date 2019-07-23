//
//  ShadowedImageView.swift
//  DoddleDo
//
//  Created by Xuzh on 2019/7/23.
//  Copyright © 2019 Xuzh. All rights reserved.
//

import UIKit

class ShadowedImageView: UIImageView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.layer.shadowOffset = CGSize(width: 4.0, height: 3.0)
        self.layer.shadowOpacity = 0.9
        self.layer.shadowRadius = 3.0
        self.clipsToBounds = false
    }

}
