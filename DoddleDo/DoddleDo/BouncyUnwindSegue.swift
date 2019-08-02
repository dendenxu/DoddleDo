//
//  BouncyUnwindSegue.swift
//  DoddleDo
//
//  Created by Xuzh on 2019/8/1.
//  Copyright © 2019 Xuzh. All rights reserved.
//

import UIKit

class BouncyUnwindSegue: UIStoryboardSegue {
    
    var sourceZoomPoint = CGPoint(x: 0, y: 0)
    var desinationZoomPoint = CGPoint(x: 0, y: constants.screenHeight)
    
    override func perform() {
        if let previousView = source.view, let backView = destination.view, let window = UIApplication.shared.keyWindow {
            let screenHeight = UIScreen.main.bounds.size.height
            let screenWidth = UIScreen.main.bounds.size.width
            window.insertSubview(backView, aboveSubview: previousView)

            for subView in backView.subviews {
                subView.frame = subView.frame.zoom(about: CGPoint(x: 0, y: 0), by: constants.scale)
            }
            backView.frame = CGRect(origin: sourceZoomPoint, size: constants.sharedZoomSize)
            UIView.animate(
                withDuration: constants.animationDuration,
                delay: 0,
                usingSpringWithDamping: constants.animationSpringDamping,
                initialSpringVelocity: 0,
                options: [.curveEaseInOut, .allowUserInteraction, .allowAnimatedContent],
                animations: {
                    previousView.frame = CGRect(origin: self.desinationZoomPoint, size: constants.sharedZoomSize)
                    for subView in previousView.subviews {
                        subView.frame = subView.frame.zoom(about: CGPoint(x: 0, y: 0), by: constants.scale)
                    }
                    backView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
                    for subView in backView.subviews {
                        subView.frame = subView.frame.zoom(about: CGPoint(x: 0, y: 0), by: 1/constants.scale)
                    }
                },
                completion: { finished in
                    self.source.dismiss(animated: false, completion: nil)
                }
            )
        }
    }
}

extension BouncyUnwindSegue {
    private struct constants {
        static let screenHeight = UIScreen.main.bounds.size.height
        static let screenWidth = UIScreen.main.bounds.size.width
        static let sharedZoomSize = CGSize(width: constants.screenWidth * scale, height: constants.screenHeight * scale)
        static let scale: CGFloat = 0.01
        static let animationDuration: Double = 0.45
        static let animationSpringDamping:CGFloat = 0.7
    }
}
