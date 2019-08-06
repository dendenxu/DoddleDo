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
        if let currentView = source.view, let backView = destination.view, let window = UIApplication.shared.keyWindow {

            window.insertSubview(backView, aboveSubview: currentView)
            
            let currentSnapshot = UIImageView(image: takeSnapShotOf(view: currentView))
            let backSnapshot = UIImageView(image: takeSnapShotOf(view: backView))
            backSnapshot.frame = CGRect(origin: sourceZoomPoint, size: constants.sharedZoomSize)
            currentView.isHidden = true
            backView.isHidden = true
            window.addSubview(backSnapshot)
            window.addSubview(currentSnapshot)

            UIView.animate(
                withDuration: constants.animationDuration,
                delay: 0,
                usingSpringWithDamping: constants.animationSpringDamping,
                initialSpringVelocity: 0,
                options: [.curveEaseInOut, .allowAnimatedContent],
                animations: {

                    currentSnapshot.frame = CGRect(origin: self.desinationZoomPoint, size: constants.sharedZoomSize)
                    backSnapshot.frame = CGRect(x: 0, y: 0, width: constants.screenWidth, height: constants.screenHeight)
                },
                completion: { finished in
                    currentSnapshot.removeFromSuperview()
                    backSnapshot.removeFromSuperview()
                    backView.isHidden = false
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
        static let scale: CGFloat = 0.001
        static let animationDuration: Double = 0.45
        static let animationSpringDamping: CGFloat = 0.7
    }
}
