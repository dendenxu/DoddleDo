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
    var brushWidth: CGFloat = 70
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
    func circleDistance(between point: CGPoint) -> CGFloat {
        return sqrt(pow(abs(self.x - point.x), 2) + pow(abs(self.y - point.y), 2))
    }
}

extension CGSize {
    func zoom(by scale: CGFloat) -> CGSize {
        return CGSize(width: self.width * scale, height: self.width * scale)
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
        
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped(recognizer:)))
        tap.delegate = self

        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped(recognizer:)))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.delegate = self

        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(recognizer:)))
        longPress.allowableMovement = 2
        longPress.minimumPressDuration = 0.1
        longPress.delegate = self
        longPress.name = "mainLongPress"

//        let pan = UIPanGestureRecognizer(target: self, action: #selector(panned(recognizer:)))
//        pan.delegate = self
//        pan.name = "editButtonsPanned"

        view.addGestureRecognizer(tap)
        view.addGestureRecognizer(doubleTap)
        view.addGestureRecognizer(longPress)
//        view.addGestureRecognizer(pan)

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

        brushWidthPalette["mountain"] = constants.initialBrushWidth
        brushWidthPalette["grass"] = constants.initialBrushWidth
        brushWidthPalette["tree"] = constants.initialBrushWidth
        brushWidthPalette["house"] = constants.initialBrushWidth
        brushWidthPalette["sky"] = constants.initialBrushWidth
        brushWidthPalette["river"] = constants.initialBrushWidth
        brushWidthPalette["road"] = constants.initialBrushWidth
        brushWidthPalette["stone"] = constants.initialBrushWidth
        brushWidthPalette["eraser"] = constants.initialEraserWidth



        // FIXME: The whole screen rect gets filled with white when seguing to board
        UIGraphicsBeginImageContextWithOptions(view.frame.size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(colorPalette["eraser"]?.cgColor ?? UIColor.black.cgColor)
        context.fill(view.bounds)
        mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

    }

    @IBOutlet weak var back: ShadowedImageView! {
        didSet {
            addButtonTappedOrPressedGestureRecognizer(to: back)
        }
    }

    // MARK: Temporary: temporarily using finger as undo gesture recognizer
    func fingerTapped() {
        if let image = tempImages.popLast() {
            recycleBin.append(image)
        }
        caller = "undo"
    }
    private var caller: String?


    func recycleFingerTapped() {
        if let image = recycleBin.popLast(), let caller = caller, caller == "undo" || caller == "redo" {
            tempImages.append(image)
            self.caller = "redo"
        } else {
            recycleBin = [AttributedImage]()
        }
    }

    // MARK: Buttons: animations and gesture recognizers
    @IBOutlet weak var buttonsView: UIView! {
        didSet {
            for view in buttonsView.subviews {
                if let view = view as? ShadowedImageView {
                    addButtonTappedOrPressedGestureRecognizer(to: view)
                    let pan = UIPanGestureRecognizer(target: self, action: #selector(buttonPanned(recognizer:)))
                    pan.name = view.identifier
                    pan.delegate = self
                    view.addGestureRecognizer(pan)
                    view.isUserInteractionEnabled = true
                }
            }
        }
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if let recognizerView = gestureRecognizer.view, let otherView = otherGestureRecognizer.view, recognizerView.isEqual(otherView), gestureRecognizer.isKind(of: UILongPressGestureRecognizer.self) && otherGestureRecognizer.isKind(of: UIPanGestureRecognizer.self) || otherGestureRecognizer.isKind(of: UILongPressGestureRecognizer.self) && gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) {
            return true
        } else if let nameOfFirst = gestureRecognizer.name, let nameOfSecond = otherGestureRecognizer.name, nameOfFirst == "mainLongPress" && nameOfSecond == "editButtonsPanned" || nameOfSecond == "mainLongPress" && nameOfFirst == "editButtonsPanned" {
            return true
        } else {
            return false
        }
    }

    private var originalCenter: CGPoint?
    private var originalBrushWidth: CGFloat?
    @objc func buttonPanned(recognizer: UIPanGestureRecognizer) {

        if let identifier = recognizer.name, colorPalette[identifier] != nil {
            switch recognizer.state {
            case .began:
                brushWidth = brushWidthPalette[identifier]!
                originalBrushWidth = brushWidth
                originalCenter = recognizer.view?.center
                let width = UIImageView()
                guard let name = (recognizer.view as? ShadowedImageView)?.identifier else { return }
                brush = name
                if name == "eraser" {
                    width.image = UIImage(named: "eraserWidth")
                    width.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: constants.eraserWidthUpperBound, height: constants.eraserWidthUpperBound * 1.5))
                    width.center = originalCenter!
                    width.center.y = originalCenter!.y + constants.eraserWidthUpperBound * 1.5 / 2 - originalBrushWidth! * 1.5
                } else {
                    width.image = UIImage(named: "width")
                    width.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: constants.brushWidthUpperBound, height: constants.brushWidthUpperBound * 1.5))
                    width.center = originalCenter!
                    width.center.y = originalCenter!.y + constants.brushWidthUpperBound * 1.5 / 2 - originalBrushWidth! * 1.5
                }
                width.contentMode = .scaleAspectFit
                buttonsView.insertSubview(width, at: 0)

            case .changed:
                let dy = recognizer.translation(in: view.superview!).y
                brushWidth = originalBrushWidth! + dy / 1.5
                brushWidthPalette[identifier]! = brushWidth

                if brushWidthPalette[identifier]! > constants.brushWidthLowerBound && brushWidthPalette[identifier]! < constants.brushWidthUpperBound {
                    recognizer.view?.center.y = originalCenter!.y + dy
                } else if brushWidthPalette[identifier]! > constants.eraserWidthLowerBound && brushWidthPalette[identifier]! < constants.eraserWidthUpperBound && identifier == "eraser" {
                    recognizer.view?.center.y = originalCenter!.y + dy
                }

            case .ended:
                UIView.animate(
                    withDuration: 0.1,
                    delay: 0,
                    options: .curveEaseInOut,
                    animations: {
                        recognizer.view?.center = self.originalCenter!
                        if let name = (recognizer.view as? ShadowedImageView)?.identifier, name == "eraser" {
                            self.buttonsView.subviews[0].center.y = self.originalCenter!.y + constants.eraserWidthUpperBound * 1.5 / 2 - self.brushWidth * 1.5

                        } else {
                            self.buttonsView.subviews[0].center.y = self.originalCenter!.y + constants.brushWidthUpperBound * 1.5 / 2 - self.brushWidth * 1.5

                        }
                    }
                ) { finished in
                    UIView.animate(
                        withDuration: 0.05,
                        delay: 0.05,
                        options: .curveLinear,
                        animations: {
                            self.buttonsView.subviews[0].alpha = 0
                        },
                        completion: nil
                    )
                    self.buttonsView.subviews[0].removeFromSuperview()
                }


            default: break
            }

        }
    }

//    private var shouldRecognizeEditButtonsPan = false
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//        if !shouldRecognizeEditButtonsPan && gestureRecognizer.name == "editButtonsPanned" {
//            return false
//        } else {
//            return true
//        }
//    }

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
        } else if gestureRecognizer.isKind(of: UILongPressGestureRecognizer.self), let second = otherGestureRecognizer as? UITapGestureRecognizer, second.numberOfTapsRequired == 2 {
            return true
        } else if let name = gestureRecognizer.name, name == "editButtonsPanned", gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) {
            if let other = otherGestureRecognizer as? UILongPressGestureRecognizer, other.name == "mainLongPress" {
                return false
            } else {
                return true
            }
        } else {
            return false
        }

    }

    var editButtonsAnimationFinished = false
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let isLast = anim.value(forKey: "isLast") as? Bool, isLast {
            view.isUserInteractionEnabled = true
        }
        if let _ = anim.value(forKey: "view") as? UIView, let isDoubleTappedOrLongPressed = anim.value(forKey: "isDoubleTappedOrLongPressed")as? Bool, isDoubleTappedOrLongPressed {
            if flag {
                editButtonsAnimationFinished = true
            }
        }
    }

    func animationDidStart(_ anim: CAAnimation) {
        if let view = anim.value(forKey: "view") as? UIView, let isDoubleTappedOrLongPressed = anim.value(forKey: "isDoubleTappedOrLongPressed")as? Bool, isDoubleTappedOrLongPressed {
            view.isHidden = false
        }
    }

    @objc func tapped(recognizer: UITapGestureRecognizer) {
        if !buttonsView.isHidden {
            view.isUserInteractionEnabled = false
            var count: Int = 0
            delay(seconds: constants.buttonsDisappearAnimationDuration + Double(buttonsView.subviews.count - 1) * constants.buttonsAnimationDelay) {
                self.buttonsView.isHidden = true
                self.view.isUserInteractionEnabled = true
            }
            for view in buttonsView.subviews {
                let originalCenter = view.center
                UIView.animate(
                    withDuration: constants.buttonsDisappearAnimationDuration,
                    delay: constants.buttonsAnimationDelay * Double(count),
                    usingSpringWithDamping: 0.8,
                    initialSpringVelocity: 0,
                    options: .curveEaseInOut,
                    animations: {
                        view.alpha = 0
//                        view.center = self.buttonsView.subviews[0].center
//                        view.center = self.buttonsOriginalPosition!
                        view.center = recognizer.location(in: self.buttonsView)

                    },
                    completion: { finished in
                        view.isHidden = true
                        view.alpha = 1
                        view.center = originalCenter
                    }
                )
                count = count == buttonsView.subviews.count - 1 ? count : count + 1
            }
        }
    }

//    private var buttonsOriginalPosition: CGPoint?
    @objc func doubleTapped(recognizer: UITapGestureRecognizer) {

        if buttonsView.isHidden {
            buttonsView.center = CGPoint(x: recognizer.location(in: view).x, y: recognizer.location(in: view).y - 50)
            view.isUserInteractionEnabled = false
            buttonsView.isHidden = false
//            buttonsOriginalPosition = recognizer.location(in: buttonsView)
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
                group.duration = constants.buttonsAppearAnimationDuration
                group.beginTime = constants.buttonsAnimationDelay * Double(count) + CACurrentMediaTime()
                group.delegate = self
                group.setValue(view, forKey: "view")
                group.setValue(true, forKey: "isDoubleTappedOrLongPressed")

                if count == buttonsView.subviews.count - 1 {
                    group.setValue(true, forKey: "isLast")
                }
                view.layer.add(group, forKey: nil)
                count += 1
            }
        }
    }


    private func delay(seconds: Double, completion: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
    }

    private var editButtonsAnimationStartTime: CFTimeInterval?
    @IBOutlet weak var editButtonsView: UIView! {
        didSet {
            for view in editButtonsView.subviews {
//                addButtonTappedOrPressedGestureRecognizer(to: view as! ShadowedImageView)
                view.isUserInteractionEnabled = true
            }
        }
    }
    // TODO: Get rid of the finger

//    @objc func panned(recognizer: UIPanGestureRecognizer) {
//        switch recognizer.state {
//        case .ended:
//            shouldRecognizeEditButtonsPan = false
//        default: break
//        }
//    }

    @objc func longPressed(recognizer: UILongPressGestureRecognizer) {
        switch recognizer.state {
        case .began:
//                shouldRecognizeEditButtonsPan = true
            editButtonsView.center = CGPoint(x: recognizer.location(in: view).x, y: recognizer.location(in: view).y - 20)
            editButtonsView.isHidden = false
            editButtonsAnimationStartTime = CACurrentMediaTime()
            var count: Int = 0
            for view in editButtonsView.subviews {
                view.isHidden = true
                // Magic animation. Don't touch. Toggled for an hour.
                let alpha = CABasicAnimation(keyPath: "opacity")
                alpha.fromValue = 0
                alpha.toValue = 1

                let flyX = CASpringAnimation(keyPath: "position.x")
                flyX.damping = 20
                flyX.stiffness = 400
                flyX.initialVelocity = 0.0
                flyX.fromValue = recognizer.location(in: editButtonsView).x
                flyX.toValue = view.center.x

                let flyY = CASpringAnimation(keyPath: "position.y")
                flyY.damping = 20
                flyY.stiffness = 400
                flyY.initialVelocity = 0.0
                flyY.fromValue = recognizer.location(in: editButtonsView).y
                flyY.toValue = view.center.y

                let group = CAAnimationGroup()
                group.animations = [flyX, flyY, alpha]
                group.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
                group.duration = 0.3
                // MARK: Delayed buttons fading in animation
                // Uncomment this line to enable
                group.beginTime = constants.buttonsAnimationDelay * Double(count) + CACurrentMediaTime()
                group.delegate = self
                group.setValue(view, forKey: "view")
                group.setValue(true, forKey: "isDoubleTappedOrLongPressed")

                if count == editButtonsView.subviews.count - 1 {
                    group.setValue(true, forKey: "isLast")
                }
                view.layer.add(group, forKey: nil)
                count += 1
            }
            editButtonsAnimationFinished = false

        case .changed:
            if let view = editButtonsView.hitTest(recognizer.location(in: editButtonsView), with: nil) as? ShadowedImageView {
                UIView.animate(
                    withDuration: constants.buttonTappedOrPressedAnimationDuration,
                    delay: 0,
                    usingSpringWithDamping: constants.buttonTappedOrPressedSpringDamping,
                    initialSpringVelocity: 0,
                    options: [],
                    animations: {
                        view.transform = CGAffineTransform.identity.scaledBy(x: constants.buttonTappedOrPressedTransformScale, y: constants.buttonTappedOrPressedTransformScale)
                    }
                )
            }

        case .ended:
            if let view = editButtonsView.hitTest(recognizer.location(in: editButtonsView), with: nil) as? ShadowedImageView, let name = view.identifier {
                UIView.animate(
                    withDuration: constants.buttonTappedOrPressedAnimationDuration,
                    delay: 0,
                    usingSpringWithDamping: constants.buttonTappedOrPressedSpringDamping,
                    initialSpringVelocity: 0,
                    options: [],
                    animations: {
                        view.transform = CGAffineTransform.identity
                    }
                ){ finished in
                    if name == "finish" {
                        let tempLocation = recognizer.location(in: self.view)
                        self.performSegue(withIdentifier: name, sender: tempLocation)
                    } else if name == "finger" {
                        self.fingerTapped()
                    } else if name == "recycleFinger" {
                        self.recycleFingerTapped()
                    }
                }
            }

            var count: Int = 0
            let location = recognizer.location(in: self.editButtonsView)
            delay(seconds: constants.buttonsDisappearAnimationDuration + (editButtonsAnimationFinished ? 0 : constants.buttonsAppearAnimationDuration - CACurrentMediaTime() + editButtonsAnimationStartTime! + 0.01) + Double(editButtonsView.subviews.count - 1) * constants.buttonsAnimationDelay) {
                self.editButtonsView.isHidden = true
                self.view.isUserInteractionEnabled = true
            }
            for view in editButtonsView.subviews {
                let originalCenter = view.center
                self.view.isUserInteractionEnabled = false
                delay(seconds: editButtonsAnimationFinished ? 0 : (constants.buttonsAppearAnimationDuration - CACurrentMediaTime() + editButtonsAnimationStartTime!) + 0.01 + Double(count) * constants.buttonsAnimationDelay) {
                    UIView.animate(
                        withDuration: constants.buttonsDisappearAnimationDuration,
                        delay: 0,
                        usingSpringWithDamping: 0.8,
                        initialSpringVelocity: 0,
                        options: .curveEaseInOut,
                        animations: {
                            view.alpha = 0
                            view.center = location
                        },
                        completion: { finished in
                            view.isHidden = true
                            view.alpha = 1
                            view.center = originalCenter
                        }
                    )
                }
                count = count == editButtonsView.subviews.count - 1 ? count : count + 1
            }

        default: break
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
                UIGraphicsBeginImageContextWithOptions(view.frame.size, false, 0.0)
                framedImage?.draw(in: view.bounds)
                tempImages[0].image?.draw(in: view.bounds)
                framedImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()

                updateMain(from: 1)
            } else {
                updateMain(from: 0)
            }

            caller = nil
        }
    }

    var recycleBin = [AttributedImage]()

    private func updateMain(from: Int) {
        UIGraphicsBeginImageContextWithOptions(view.frame.size, false, 0.0)
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
    lazy var color = self.colorPalette[brush] ?? UIColor(rgb: 0x6cc0ff)
    var brush = "sky"
    // TODO: Add "brush" feature using MaLiang
    private var realBrushWidth: CGFloat = constants.initialBrushWidth
    var brushWidth: CGFloat {
        get {
            return realBrushWidth
        }
        set {
            if newValue > constants.brushWidthUpperBound && brush != "eraser" {
                realBrushWidth = constants.brushWidthUpperBound
            } else if newValue < constants.brushWidthLowerBound && brush != "eraser" {
                realBrushWidth = constants.brushWidthLowerBound
            } else if newValue > constants.eraserWidthUpperBound {
                realBrushWidth = constants.eraserWidthUpperBound
            } else if newValue < constants.eraserWidthLowerBound {
                realBrushWidth = constants.eraserWidthLowerBound
            } else {
                realBrushWidth = newValue
            }
        }
    }
    var opacity: CGFloat = 1.0
    var blendMode = CGBlendMode.normal
    private var lastPoint = CGPoint.zero
    private var points = [CGPoint]()
    private var swipe = false
    private var firstTouch = CGPoint.zero

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        swipe = false
        lastPoint = touch.location(in: view)
        firstTouch = lastPoint
        points.append(lastPoint)

    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let currentPoint = touch.location(in: view)
        points.append(currentPoint)

        if !swipe && currentPoint.circleDistance(between: firstTouch) > 2 {
            drawLine(from: lastPoint, to: currentPoint)
            swipe = true
        } else if swipe {
            drawLine(from: lastPoint, to: currentPoint)
        }
        lastPoint = currentPoint

    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let currentPoint = touch.location(in: view)
        thisDrawFinished(at: currentPoint)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let currentPoint = touch.location(in: view)
        thisDrawFinished(at: currentPoint)
    }

    private func drawLine(from fromPoint: CGPoint, to toPoint: CGPoint) {
        UIGraphicsBeginImageContextWithOptions(view.frame.size, false, 1.0)
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

    private func thisDrawFinished(at point: CGPoint) {

        points.append(point)
        let tempImage = AttributedImage()

        if swipe, points.count >= 2 {
            drawLine(from: lastPoint, to: lastPoint)

            UIGraphicsBeginImageContextWithOptions(view.frame.size, false, 0.0)
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


}

extension DoddleBoardViewController {
    private struct constants {
        static let initialBrushWidth: CGFloat = 40
        static let initialEraserWidth: CGFloat = 60
        static let brushWidthLowerBound: CGFloat = 5
        static let eraserWidthLowerBound: CGFloat = 5
        static let brushWidthUpperBound: CGFloat = 140
        static let eraserWidthUpperBound: CGFloat = 200
        static let buttonsAppearAnimationDuration: Double = 0.3
        static let buttonsDisappearAnimationDuration: Double = 0.3
        static let buttonsAnimationDelay: Double = 0
    }
}
