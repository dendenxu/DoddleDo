//
//  CustomUnwindSegue.swift
//  DoddleDo
//
//  Created by Xuzh on 2019/8/1.
//  Copyright © 2019 Xuzh. All rights reserved.
//

import UIKit

class CustomUnwindSegue: UIStoryboardSegue {
    override func perform() {
        if let previousView = source.view, let backView = destination.view, let window = UIApplication.shared.keyWindow {
            let screenHeight = UIScreen.main.bounds.size.height
            let screenWidth = UIScreen.main.bounds.size.width
            window.insertSubview(backView, aboveSubview: previousView)

            for subView in backView.subviews {
                subView.frame = subView.frame.zoom(about: CGPoint(x: 0, y: 0), by: 0.01)
            }
            backView.frame = CGRect(x: 0, y: 0, width: 0.01 * screenWidth, height: 0.01 * screenHeight)
            UIView.animate(
                withDuration: 0.45,
                delay: 0,
                usingSpringWithDamping: 0.7,
                initialSpringVelocity: 0,
                options: [.curveEaseInOut, .allowUserInteraction, .allowAnimatedContent],
                animations: {
                    previousView.frame = CGRect(x: 0, y: screenHeight, width: 0.01 * screenWidth, height: 0.01 * screenHeight)
                    for subView in previousView.subviews {
                        subView.frame = subView.frame.zoom(about: CGPoint(x: 0, y: 0), by: 0.01)
                    }
                    backView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
                    for subView in backView.subviews {
                        subView.frame = subView.frame.zoom(about: CGPoint(x: 0, y: 0), by: 100)
                    }
                },
                completion: { finished in
                    self.source.dismiss(animated: false, completion: nil)
                }
            )
        }

    }
}
