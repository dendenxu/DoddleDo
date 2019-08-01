//
//  CustomSegue.swift
//  DoddleDo
//
//  Created by Xuzh on 2019/8/1.
//  Copyright © 2019 Xuzh. All rights reserved.
//

import UIKit

class CustomSegue: UIStoryboardSegue {
    override func perform() {
        if let sourceView = source.view, let destinationView = destination.view, let window = UIApplication.shared.keyWindow {
            window.insertSubview(destinationView, aboveSubview: sourceView)
            let screenHeight = UIScreen.main.bounds.size.height
            let screenWidth = UIScreen.main.bounds.size.width

            for subView in destinationView.subviews {
                subView.frame = subView.frame.zoom(about: CGPoint(x: 0, y: 0), by: 0.01)
            }
            destinationView.frame = CGRect(x: 0, y: screenHeight, width: 0.01 * screenWidth, height: 0.01 * screenHeight)
            UIView.animate(
                withDuration: 0.45,
                delay: 0,
                usingSpringWithDamping: 0.7,
                initialSpringVelocity: 0,
                options: .curveEaseInOut,
                animations: {
                    sourceView.frame = CGRect(x: 0, y: 0, width: 0.01 * screenWidth, height: 0.01 * screenHeight)
                    for subView in sourceView.subviews {
                        subView.frame = subView.frame.zoom(about: CGPoint(x: 0, y: 0), by: 0.01)
                    }
                    destinationView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
                    for subView in destinationView.subviews {
                        subView.frame = subView.frame.zoom(about: CGPoint(x: 0, y: 0), by: 100)
                    }
                },
                completion: { finished in
                    for subView in sourceView.subviews {
                        subView.frame = subView.frame.zoom(about: CGPoint(x: 0, y: 0), by: 100)
                    }
                    self.source.present(self.destination, animated: false, completion: nil)
                }
            )
//            self.source.present(self.destination, animated: false, completion: nil)
        }
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
