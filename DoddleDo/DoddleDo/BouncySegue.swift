//
//  BouncySegue.swift
//  DoddleDo
//
//  Created by Xuzh on 2019/8/1.
//  Copyright © 2019 Xuzh. All rights reserved.
//

import UIKit

class BouncySegue: UIStoryboardSegue {
    
    var desinationZoomPoint = CGPoint(x: 0, y: constants.screenHeight)
    var sourceZoomPoint = CGPoint(x: 0, y: 0)
    
    override func perform() {
        if let sourceView = source.view, let destinationView = destination.view, let window = UIApplication.shared.keyWindow {
            window.insertSubview(destinationView, aboveSubview: sourceView)

            for subView in destinationView.subviews {
                subView.frame = subView.frame.zoom(about: CGPoint(x: 0, y: 0), by: constants.scale)
            }
            destinationView.frame = CGRect(origin: desinationZoomPoint, size: constants.sharedZoomSize)
            UIView.animate(
                withDuration: constants.animationDuration,
                delay: 0,
                usingSpringWithDamping: constants.animationSpringDamping,
                initialSpringVelocity: 0,
                options: .curveEaseInOut,
                animations: {
                    sourceView.frame = CGRect(origin: self.sourceZoomPoint, size: constants.sharedZoomSize)
                    for subView in sourceView.subviews {
                        subView.frame = subView.frame.zoom(about: CGPoint(x: 0, y: 0), by: constants.scale)
                    }
                    destinationView.frame = CGRect(x: 0, y: 0, width: constants.screenWidth, height: constants.screenHeight)
                    for subView in destinationView.subviews {
                        subView.frame = subView.frame.zoom(about: CGPoint(x: 0, y: 0), by: 1/constants.scale)
                    }
                },
                completion: { finished in
                    for subView in sourceView.subviews {
                        subView.frame = subView.frame.zoom(about: CGPoint(x: 0, y: 0), by: 1/constants.scale)
                    }
                    self.source.present(self.destination, animated: false, completion: nil)
                }
            )
        }
    }
}

extension BouncySegue {
    private struct constants {
        static let screenHeight = UIScreen.main.bounds.size.height
        static let screenWidth = UIScreen.main.bounds.size.width
        static let sharedZoomSize = CGSize(width: constants.screenWidth * scale, height: constants.screenHeight * scale)
        static let scale: CGFloat = 0.01
        static let animationDuration: Double = 0.65
        static let animationSpringDamping:CGFloat = 0.7
    }
}

extension CGRect {
    func zoom(about origin: CGPoint, by scale: CGFloat) -> CGRect {
        let newWidth = width * scale
        let newHeight = height * scale
        let newX = (minX - origin.x) * scale + origin.x
        let newY = (minY - origin.y) * scale + origin.y
        return CGRect(x: newX, y: newY, width: newWidth, height: newHeight)
    }
}
