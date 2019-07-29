//
//  BackgroundImageView.swift
//  DoddleDo
//
//  Created by Xuzh on 2019/7/23.
//  Copyright © 2019 Xuzh. All rights reserved.
//

import UIKit

@IBDesignable
class MainSceneBackgroundImageView: UIImageView {

    lazy var nameImageView = createNameImageView()

    private func createNameImageView() -> ShadowedImageView {
        let nameImageView = ShadowedImageView(image: UIImage(named: "name", in: Bundle(for: classForCoder), compatibleWith: traitCollection))
        addSubview(nameImageView)
        return nameImageView
    }

    lazy var bottomLine: UILabel = createBottomLine()

    private func createBottomLine() -> UILabel {
        let font = UIFont.preferredFont(forTextStyle: .caption2).withSize(25.0)
        let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1),
                .font: font,
                .kern: 2.0
        ]
        let attributedText = NSAttributedString(string: "Doddle makes you do it", attributes: attributes)
        let label = UILabel()
        label.attributedText = attributedText
        addSubview(label)
        return label
    }

    override func layoutSubviews() {
        nameImageView.frame = CGRect(x: 64, y: 52, width: 384, height: 89)
        
        bottomLine.frame.size = CGSize.zero
        bottomLine.sizeToFit()
        bottomLine.center = CGPoint(x: 342, y: 354)
    }
    

}

