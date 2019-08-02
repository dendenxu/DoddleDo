//
//  DoddleBoardViewController.swift
//  DoddleDo
//
//  Created by Xuzh on 2019/8/1.
//  Copyright © 2019 Xuzh. All rights reserved.
//

import UIKit

class DoddleBoardViewController: UIViewController {
    @IBOutlet weak var back: ShadowedImageView! {
        didSet {
            addButtonTappedOrPressedGestureRecognizer(to: back)
        }
    }

    var backPoint = CGPoint()

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let bouncyUnwindSegue = segue as? BouncyUnwindSegue {
            bouncyUnwindSegue.desinationZoomPoint = backPoint
        }
    }

    override func viewDidLoad() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped(recognizer:)))
        doubleTap.numberOfTapsRequired = 2
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(recognizer:)))
        view.addGestureRecognizer(doubleTap)
        view.addGestureRecognizer(longPress)
    }

    @objc func doubleTapped(recognizer: UITapGestureRecognizer) {
        tempImages.popLast()
    }

    @objc func longPressed(recognizer: UILongPressGestureRecognizer) {

    }

    @IBOutlet weak var mainImageView: UIImageView!

    @IBOutlet weak var tempImageView: UIImageView!

    @IBOutlet weak var finish: ShadowedImageView! {
        didSet {
            let tapOrPress = UILongPressGestureRecognizer(target: self, action: #selector(buttonTappedOrPressed(recognizer:)))
            tapOrPress.minimumPressDuration = 0
            finish.addGestureRecognizer(tapOrPress)
            finish.isUserInteractionEnabled = true
        }
    }

    var tempImages = [AttributedImage]() {
        didSet {
            UIGraphicsBeginImageContext(view.frame.size)
            mainImageView.image = nil
            for i in 0..<tempImages.count {
                let tempImage = tempImages[i]
                tempImage.image?.draw(in: view.bounds, blendMode: tempImage.blendMode, alpha: tempImage.opacity)
            }
            mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
            mainImageView.alpha = 1.0
            UIGraphicsEndImageContext()
        }
    }

    var lastPoint = CGPoint.zero
    var color = UIColor.blue
    var brushWidth: CGFloat = 30.0
    var opacity: CGFloat = 1.0
    var blendMode = CGBlendMode.normal
    private var points = [CGPoint]()
    private var swipe = false

    func drawLine(from fromPoint: CGPoint, to toPoint: CGPoint) {
        UIGraphicsBeginImageContext(view.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        tempImageView.image?.draw(in: view.bounds)
        context.move(to: fromPoint)
        context.addLine(to: toPoint)
        context.setLineCap(.round)
        context.setBlendMode(.normal)
        context.setStrokeColor(color.cgColor)
        context.setLineWidth(brushWidth)
        context.strokePath()
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        tempImageView.alpha = opacity
        UIGraphicsEndImageContext()
    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }

        swipe = false
        lastPoint = touch.location(in: view)
        points.append(lastPoint)

    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        swipe = false
        tempImageView.image = nil
        points = [CGPoint]()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        guard let touch = touches.first else { return }
        let currentPoint = touch.location(in: view)

        swipe = true
        points.append(currentPoint)
        drawLine(from: lastPoint, to: currentPoint)
        lastPoint = currentPoint
        
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let currentPoint = touch.location(in: view)
        points.append(currentPoint)

        if swipe {
            drawLine(from: lastPoint, to: lastPoint)
            let tempImage = AttributedImage()
            UIGraphicsBeginImageContext(view.frame.size)
            guard let context = UIGraphicsGetCurrentContext() else { return }
            context.addPath(computePath(of: points, with: 6))
            if points.count >= 2 {
                context.move(to: points[points.count - 2])
                context.addLine(to: points[points.count - 1])
                context.move(to: points[0])
                context.addLine(to: points[1])
            } else {
                points = [CGPoint]()
                tempImageView.image = nil
                return
            }
            context.setStrokeColor(color.cgColor)
            context.setLineWidth(brushWidth)
            context.setLineCap(.round)
            context.setBlendMode(.normal)
            context.strokePath()
            tempImage.image = UIGraphicsGetImageFromCurrentImageContext()
            tempImage.opacity = opacity
            tempImage.blendMode = .normal
            UIGraphicsEndImageContext()
            tempImages.append(tempImage)
        }

        points = [CGPoint]()
        tempImageView.image = nil
    }

    private func computePath(of points: [CGPoint], with factor: CGFloat) -> CGPath {
        let path = UIBezierPath()
        let tempPoints = [points[1]] + points + [points[points.count - 1]]
        path.move(to: points[0])
        for i in 1..<tempPoints.count - 2 {
            let control1 = CGPoint(x: tempPoints[i].x + (tempPoints[i + 1].x - tempPoints[i - 1].x) / factor, y: tempPoints[i].y + (tempPoints[i + 1].y - tempPoints[i - 1].y) / factor)
            let control2 = CGPoint(x: tempPoints[i + 1].x - (tempPoints[i + 2].x - tempPoints[i].x) / factor, y: tempPoints[i + 1].y - (tempPoints[i + 2].y - tempPoints[i].y) / factor)
            path.addCurve(to: tempPoints[i + 1], controlPoint1: control1, controlPoint2: control2)
        }
        return path.cgPath
    }
}

extension CGPoint {
    static func mid(of point1: CGPoint, and point2: CGPoint) -> CGPoint {
        return CGPoint(x: (point1.x + point2.x) / 2, y: (point1.y + point2.y) / 2)
    }

    func rectDistance(between point: CGPoint) -> CGFloat {
        return abs(self.x - point.x) + abs(self.y - point.y)
    }
}


class AttributedImage {
    var opacity: CGFloat = 1.0
    var blendMode = CGBlendMode.normal
    var image: UIImage?
}
