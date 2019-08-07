//
//  BouncySegue.swift
//  DoddleDo
//
//  Created by Xuzh on 2019/8/1.
//  Copyright © 2019 Xuzh. All rights reserved.
//

import UIKit

class BouncySegue: UIStoryboardSegue {

    var desinationZoomPoint = CGPoint(x: 0, y: UIView.constants.screenHeight)
    var sourceZoomPoint = CGPoint(x: 0, y: 0)

    override func perform() {
        if let sourceView = source.view, let destinationView = destination.view, let window = UIApplication.shared.keyWindow {

            window.insertSubview(destinationView, aboveSubview: sourceView)

            let sourceSnapshot = UIImageView(image: takeSnapShotOf(view: sourceView))
            let destinationSnapshot = UIImageView(image: takeSnapShotOf(view: destinationView))
            destinationSnapshot.frame = CGRect(origin: desinationZoomPoint, size: constants.sharedZoomSize)
            sourceView.isHidden = true
            destinationView.isHidden = true
            window.addSubview(sourceSnapshot)
            window.addSubview(destinationSnapshot)

            UIView.animate(
                withDuration: constants.animationDuration,
                delay: 0,
                usingSpringWithDamping: constants.animationSpringDamping,
                initialSpringVelocity: 0,
                options: [.curveEaseInOut, .allowAnimatedContent],
                animations: {
                    sourceSnapshot.frame = CGRect(origin: self.sourceZoomPoint, size: constants.sharedZoomSize)

                    destinationSnapshot.frame = CGRect(x: 0, y: 0, width: UIView.constants.screenWidth, height: UIView.constants.screenHeight)

                },
                completion: { finished in

                    sourceView.isHidden = false
                    destinationView.isHidden = false
                    sourceSnapshot.removeFromSuperview()
                    destinationSnapshot.removeFromSuperview()
                    self.source.present(self.destination, animated: false, completion: nil)
                }
            )
        }
    }

}

extension UIStoryboardSegue {
    func takeSnapShotOf(view: UIView?) -> UIImage? {
        guard let view = view else { return nil }

        UIGraphicsBeginImageContextWithOptions(view.frame.size, true, 0.0)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let snapShot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapShot
    }
}

extension BouncySegue {
    private struct constants {
        static let sharedZoomSize = CGSize(width: UIView.constants.screenWidth * scale, height: UIView.constants.screenHeight * scale)
        static let scale: CGFloat = 0.001
        static let animationDuration: Double = 0.45
        static let animationSpringDamping: CGFloat = 0.7
    }
}

extension UIView {
    struct constants {
        static let screenHeight = UIScreen.main.bounds.size.height
        static let screenWidth = UIScreen.main.bounds.size.width
        static let screenSize = CGSize(width: UIView.constants.screenWidth, height: UIView.constants.screenHeight)
        static let screenRect = CGRect(origin: CGPoint.zero, size: UIView.constants.screenSize)
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
