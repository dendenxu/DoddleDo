//
//  DoddleBoardViewController.swift
//  DoddleDo
//
//  Created by Xuzh on 2019/8/1.
//  Copyright © 2019 Xuzh. All rights reserved.
//

import UIKit


class AttributedImage {
    var points = [CGPoint]()
    var brushWidth: CGFloat = 70.0
    var opacity: CGFloat = 1.0
    var blendMode = CGBlendMode.normal
    var image: UIImage?
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

extension CGPoint {
    func rectDistance(between point: CGPoint) -> CGFloat {
        return abs(self.x - point.x) + abs(self.y - point.y)
    }
}

@IBDesignable
class DoddleBoardViewController: UIViewController, UIGestureRecognizerDelegate, CAAnimationDelegate {

    // MARK: Navigation
    var backPoint = CGPoint()

    @IBAction func unwindToBoard(_ unwindSegue: UIStoryboardSegue) { }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let bouncyUnwindSegue = segue as? BouncyUnwindSegue {
            bouncyUnwindSegue.desinationZoomPoint = backPoint
        } else if let bouncySegue = segue as? BouncySegue, let location = sender as? CGPoint {
            bouncySegue.desinationZoomPoint = location
            if let finish = segue.destination as? FinishSceneViewController {
                finish.backPoint = location
                finish.tempImage = mainImageView.image
            }
        }
    }

    // MARK: Initialization
    override func viewDidLoad() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped(recognizer:)))

        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped(recognizer:)))
        doubleTap.numberOfTapsRequired = 2

        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(recognizer:)))
        tap.delegate = self
        doubleTap.delegate = self
        view.addGestureRecognizer(tap)
        view.addGestureRecognizer(doubleTap)
        view.addGestureRecognizer(longPress)

        tempImageView.frame = view.frame
        mainImageView.frame = view.frame

        colorPalette["mountain"] = UIColor(rgb: 0xc3ae95)
        colorPalette["grass"] = UIColor(rgb: 0x88c23f)
        colorPalette["tree"] = UIColor(rgb: 0x078d83)
        colorPalette["house"] = UIColor(rgb: 0xb387b3)
        colorPalette["sky"] = UIColor(rgb: 0x6cc0ff)
        colorPalette["river"] = UIColor(rgb: 0x649eeb)
        colorPalette["road"] = UIColor(rgb: 0xc6c61d)
        colorPalette["stone"] = UIColor(rgb: 0xc5d8c5)
        colorPalette["eraser"] = UIColor.white

        brushWidthPalette["mountain"] = 70
        brushWidthPalette["grass"] = 70
        brushWidthPalette["tree"] = 70
        brushWidthPalette["house"] = 70
        brushWidthPalette["sky"] = 70
        brushWidthPalette["river"] = 70
        brushWidthPalette["road"] = 70
        brushWidthPalette["stone"] = 70
        brushWidthPalette["eraser"] = 70

        // FIXME: The whole screen rect gets filled with white when seguing to board
        UIGraphicsBeginImageContext(view.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(colorPalette["eraser"]?.cgColor ?? UIColor.black.cgColor)
        context.fill(view.bounds)
        mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

    }

    // TODO: Get rid of the finger
    @objc func longPressed(recognizer: UILongPressGestureRecognizer) {

    }


    @IBOutlet weak var back: ShadowedImageView! {
        didSet {
            addButtonTappedOrPressedGestureRecognizer(to: back)
        }
    }

    @IBOutlet weak var finish: ShadowedImageView! {
        didSet {
            addButtonTappedOrPressedGestureRecognizer(to: finish)
        }
    }

    @IBOutlet weak var finger: ShadowedImageView! {
        didSet {
            addButtonTappedOrPressedGestureRecognizer(to: finger)
        }
    }

    // MARK: Temporary: temporarily using finger as undo gesture recognizer
    func fingerTapped() {
        tempImages.popLast()
    }

    // MARK: Buttons: animations and gesture recognizers
    @IBOutlet weak var buttonsView: UIView! {
        didSet {
            for view in buttonsView.subviews {
                if let view = view as? ShadowedImageView {
                    addButtonTappedOrPressedGestureRecognizer(to: view)
                    let pan = UIPanGestureRecognizer(target: self, action: #selector(buttonPanned(recognizer:)))
                    pan.name = view.identifier
                    view.addGestureRecognizer(pan)
                }
            }
        }
    }

    private var originPoint: CGPoint?
    @objc func buttonPanned(recognizer: UIPanGestureRecognizer) {

        if let identifier = recognizer.name, colorPalette[identifier] != nil {
            switch recognizer.state {
            case .began:
                originPoint = recognizer.translation(in: view)

            case .changed:
                if let originPoint = originPoint {
                    let dy = recognizer.translation(in: view).y - originPoint.y
                    brushWidthPalette[identifier]! = brushWidthPalette[identifier]! + dy
                    brushWidth = brushWidthPalette[identifier]!
                }

            default: break
            }

        }
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if let single = gestureRecognizer as? UITapGestureRecognizer, let double = otherGestureRecognizer as? UITapGestureRecognizer, double.numberOfTapsRequired == 2 && single.numberOfTapsRequired == 1 && buttonsView.isHidden {
            return true
        } else {
            return false
        }
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if let single = gestureRecognizer as? UITapGestureRecognizer, let double = otherGestureRecognizer as? UITapGestureRecognizer, double.numberOfTapsRequired == 2 && single.numberOfTapsRequired == 1 {
            return true
        } else {
            return false
        }
    }

    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
//        if let view = anim.value(forKey: "view") as? UIView, let isDoubleTapped = anim.value(forKey: "isDoubleTapped")as? Bool, !isDoubleTapped {
//            view.isHidden = true
//        }
        if let isLast = anim.value(forKey: "isLast") as? Bool, isLast {
            view.isUserInteractionEnabled = true
        }
    }

    func animationDidStart(_ anim: CAAnimation) {
        if let view = anim.value(forKey: "view") as? UIView, let isDoubleTapped = anim.value(forKey: "isDoubleTapped")as? Bool, isDoubleTapped {
            view.isHidden = false
        }
    }

    var tempCount: Int = 0
    @objc func tapped(recognizer: UITapGestureRecognizer) {
        if !buttonsView.isHidden {
            view.isUserInteractionEnabled = false
            var count: Int = 0
            for view in buttonsView.subviews {
                let originalCenter = view.center
                UIView.animate(
                    withDuration: 0.3,
                    // MARK: Delayed buttons fading out animation
                    // Uncomment next line and comment the line after it to enable
                    delay: 0.01 * Double(count),
//                    delay: 0,
                    usingSpringWithDamping: 0.8,
                    initialSpringVelocity: 0,
                    options: .curveEaseInOut,
                    animations: {
                        view.alpha = 0
                        view.center = recognizer.location(in: self.buttonsView)
                    },
                    completion: { finished in
                        view.isHidden = true
                        view.alpha = 1
                        view.center = originalCenter
                        if self.tempCount == self.buttonsView.subviews.count - 1 {
                            self.buttonsView.isHidden = true
                            self.view.isUserInteractionEnabled = true
                            self.tempCount = 0
                        }
                        self.tempCount = self.tempCount + 1
                    }
                )
                count = count == buttonsView.subviews.count - 1 ? count : count + 1
            }
        }
    }

    @objc func doubleTapped(recognizer: UITapGestureRecognizer) {
        buttonsView.center = CGPoint(x: recognizer.location(in: view).x, y: recognizer.location(in: view).y - 50)
        if buttonsView.isHidden {
            view.isUserInteractionEnabled = false
            buttonsView.isHidden = false
            var count: Int = 0
            for view in buttonsView.subviews {
                view.isHidden = true
                // Magic animation. Don't touch. Toggled for an hour.
                let alpha = CABasicAnimation(keyPath: "opacity")
                alpha.fromValue = 0
                alpha.toValue = 1

                let flyX = CASpringAnimation(keyPath: "position.x")
                flyX.damping = 20
                flyX.stiffness = 400
                flyX.initialVelocity = 0.0
                flyX.fromValue = recognizer.location(in: buttonsView).x
                flyX.toValue = view.center.x

                let flyY = CASpringAnimation(keyPath: "position.y")
                flyY.damping = 20
                flyY.stiffness = 400
                flyY.initialVelocity = 0.0
                flyY.fromValue = recognizer.location(in: buttonsView).y
                flyY.toValue = view.center.y

                let group = CAAnimationGroup()
                group.animations = [flyX, flyY, alpha]
                group.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
                group.duration = 0.3
                // MARK: Delayed buttons fading in animation
                // Uncomment this line to enable
                group.beginTime = 0.01 * Double(count) + CACurrentMediaTime()
                group.delegate = self
                group.setValue(view, forKey: "view")
                group.setValue(true, forKey: "isDoubleTapped")

                if count == buttonsView.subviews.count - 1 {
                    group.setValue(true, forKey: "isLast")
                }
                view.layer.add(group, forKey: nil)
                count = count + 1
            }
        }
    }

    // MARK: Doddle board implementation
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var tempImageView: UIImageView!

    private var framedImage: UIImage?
    var bufferNumber: Int = 100
    var tempImages = [AttributedImage]() {
        didSet {
            if tempImages.count > bufferNumber {
                UIGraphicsBeginImageContext(view.frame.size)
                framedImage?.draw(in: view.bounds)
                tempImages[0].image?.draw(in: view.bounds)
                framedImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()

                updateMain(from: 1)
            } else {
                updateMain(from: 0)
            }
        }
    }

    private func updateMain(from: Int) {
        UIGraphicsBeginImageContext(view.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(colorPalette["eraser"]?.cgColor ?? UIColor.black.cgColor)
        context.fill(view.bounds)
        framedImage?.draw(in: view.bounds)
        for i in from..<tempImages.count {
            let tempImage = tempImages[i]
            tempImage.image?.draw(in: view.bounds, blendMode: tempImage.blendMode, alpha: tempImage.opacity)
        }
        mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }

    // Initializing UIColor using hex number defined in UIColor extension
    var colorPalette = [String: UIColor]()
    var brushWidthPalette = [String: CGFloat]()
    lazy var color = self.colorPalette["tree"] ?? UIColor(rgb: 0xc3ae95)

    // TODO: Add "brush" feature using MaLiang
    var brushWidth: CGFloat = 70.0
    var opacity: CGFloat = 1.0
    var blendMode = CGBlendMode.normal
    private var lastPoint = CGPoint.zero
    private var points = [CGPoint]()
    private var swipe = false

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }

        swipe = false
        lastPoint = touch.location(in: view)
        points.append(lastPoint)

    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {

        swipe = false
        if let image = tempImageView.image {
            let tempImage = AttributedImage()
            tempImage.image = image
            tempImage.opacity = opacity
            tempImage.brushWidth = brushWidth
            tempImage.blendMode = .normal
            tempImage.points = points
            tempImages.append(tempImage)
        }

        tempImageView.image = nil
        points = [CGPoint]()
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let currentPoint = touch.location(in: view)
        points.append(currentPoint)

        if currentPoint.rectDistance(between: lastPoint) > 1 {
            drawLine(from: lastPoint, to: currentPoint)
            swipe = true
        }
        lastPoint = currentPoint

    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let currentPoint = touch.location(in: view)
        points.append(currentPoint)
        let tempImage = AttributedImage()
        
        if swipe, points.count >= 2 {
            drawLine(from: lastPoint, to: lastPoint)

            UIGraphicsBeginImageContext(view.frame.size)
            guard let context = UIGraphicsGetCurrentContext() else { return }
            context.move(to: points[points.count - 2])
            context.addLine(to: points[points.count - 1])
            context.move(to: points[0])
            context.addLine(to: points[1])
            context.addPath(computePath(of: points, with: 6))
            context.setStrokeColor(color.cgColor)
            context.setLineWidth(brushWidth)
            context.setLineCap(.round)
            context.setBlendMode(.normal)
            context.strokePath()
            tempImage.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

        } else {
            tempImage.image = tempImageView.image
        }

        tempImage.opacity = opacity
        tempImage.brushWidth = brushWidth
        tempImage.blendMode = .normal
        tempImage.points = points
        tempImages.append(tempImage)
        points = [CGPoint]()
        tempImageView.image = nil
    }

    private func drawLine(from fromPoint: CGPoint, to toPoint: CGPoint) {
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

    // FIXME: Certain point may not be drawn
    // Already added some boundary test in touch event handling part. Maybe the smoothen algorithm below needs augmentation
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
