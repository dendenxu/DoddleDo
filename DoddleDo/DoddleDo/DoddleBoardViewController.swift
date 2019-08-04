//
//  DoddleBoardViewController.swift
//  DoddleDo
//
//  Created by Xuzh on 2019/8/1.
//  Copyright © 2019 Xuzh. All rights reserved.
//

import UIKit


class AttributedImage {
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

@IBDesignable
class DoddleBoardViewController: UIViewController {

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
                finish.image = mainImageView.image
            }
        }
    }

    // MARK: Initialization
    override func viewDidLoad() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped(recognizer:)))
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped(recognizer:)))
        doubleTap.numberOfTapsRequired = 2
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(recognizer:)))
        view.addGestureRecognizer(tap)
        view.addGestureRecognizer(doubleTap)
        view.addGestureRecognizer(longPress)

        tempImageView.frame = view.frame
        mainImageView.frame = view.frame
        
//        colorPalette[.mountain] = UIColor(rgb: 0xc3ae95)
//        colorPalette[.grass] = UIColor(rgb: 0x88c23f)
//        colorPalette[.tree] = UIColor(rgb: 0x078d83)
//        colorPalette[.house] = UIColor(rgb: 0xb387b3)
//        colorPalette[.sky] = UIColor(rgb: 0x6cc0ff)
//        colorPalette[.river] = UIColor(rgb: 0x649eeb)
//        colorPalette[.road] = UIColor(rgb: 0xc6c61d)
//        colorPalette[.stone] = UIColor(rgb: 0xc5d8c5)
//        colorPalette[.eraser] = UIColor.white
        colorPalette["mountain"] = UIColor(rgb: 0xc3ae95)
        colorPalette["grass"] = UIColor(rgb: 0x88c23f)
        colorPalette["tree"] = UIColor(rgb: 0x078d83)
        colorPalette["house"] = UIColor(rgb: 0xb387b3)
        colorPalette["sky"] = UIColor(rgb: 0x6cc0ff)
        colorPalette["river"] = UIColor(rgb: 0x649eeb)
        colorPalette["road"] = UIColor(rgb: 0xc6c61d)
        colorPalette["stone"] = UIColor(rgb: 0xc5d8c5)
        colorPalette["eraser"] = UIColor.white

        
        UIGraphicsBeginImageContext(view.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(colorPalette["eraser"]?.cgColor ?? UIColor.black.cgColor)
        context.fill(view.bounds)
        mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
    }

    // MARK: Temporary: temporarily using finger as property selector
    func fingerTapped() {
        
    }
    
    
    // TODO: Implement cancelling selection
    @objc func tapped(recognizer: UITapGestureRecognizer) {
        
    }
    
    // TODO: Implement color selector
    @objc func doubleTapped(recognizer: UITapGestureRecognizer) {
        tempImages.popLast()
    }

    // TODO: Get rid of the buttons
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
    
    
    @IBOutlet weak var buttonsView: UIView! {
        didSet {
            for view in buttonsView.subviews {
                addButtonTappedOrPressedGestureRecognizer(to: view as! ShadowedImageView)
            }
        }
    }
//
//    @IBOutlet weak var mountain: ShadowedImageView! {
//        didSet {
//            addButtonTappedOrPressedGestureRecognizer(to: mountain)
//        }
//    }
//    @IBOutlet weak var grass: ShadowedImageView! {
//        didSet {
//            addButtonTappedOrPressedGestureRecognizer(to: grass)
//        }
//    }
//    @IBOutlet weak var tree: ShadowedImageView! {
//        didSet {
//            addButtonTappedOrPressedGestureRecognizer(to: tree)
//        }
//    }
//    @IBOutlet weak var house: ShadowedImageView! {
//        didSet {
//            addButtonTappedOrPressedGestureRecognizer(to: house)
//        }
//    }
//    @IBOutlet weak var sky: ShadowedImageView! {
//        didSet {
//            addButtonTappedOrPressedGestureRecognizer(to: sky)
//        }
//    }
//    @IBOutlet weak var river: ShadowedImageView! {
//        didSet {
//            addButtonTappedOrPressedGestureRecognizer(to: river)
//        }
//    }
//    @IBOutlet weak var road: ShadowedImageView! {
//        didSet {
//            addButtonTappedOrPressedGestureRecognizer(to: road)
//        }
//    }
//    @IBOutlet weak var eraser: ShadowedImageView! {
//        didSet {
//            addButtonTappedOrPressedGestureRecognizer(to: eraser)
//        }
//    }
    
    
    // MARK: Doddle board implementation
    @IBOutlet weak var mainImageView: UIImageView!

    @IBOutlet weak var tempImageView: UIImageView!

    private var framedImage: UIImage?

    var bufferNumber: Int = 50
    var tempImages = [AttributedImage]() {
        didSet {
            if tempImages.count > bufferNumber {
                UIGraphicsBeginImageContext(view.frame.size)
                framedImage?.draw(in: view.bounds)
                tempImages[0].image?.draw(in: view.bounds)
                framedImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()

                UIGraphicsBeginImageContext(view.frame.size)
                guard let context = UIGraphicsGetCurrentContext() else { return }
                context.setFillColor(colorPalette["eraser"]?.cgColor ?? UIColor.black.cgColor)
                context.fill(view.bounds)
                framedImage?.draw(in: view.bounds)
                for i in 1..<tempImages.count {
                    let tempImage = tempImages[i]
                    tempImage.image?.draw(in: view.bounds, blendMode: tempImage.blendMode, alpha: tempImage.opacity)
                }
                mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()

                tempImages = [AttributedImage](tempImages.dropFirst())
            } else {
                UIGraphicsBeginImageContext(view.frame.size)
                guard let context = UIGraphicsGetCurrentContext() else { return }
                context.setFillColor(colorPalette["eraser"]?.cgColor ?? UIColor.black.cgColor)
                context.fill(view.bounds)
                framedImage?.draw(in: view.bounds)
                for i in 0..<tempImages.count {
                    let tempImage = tempImages[i]
                    tempImage.image?.draw(in: view.bounds, blendMode: tempImage.blendMode, alpha: tempImage.opacity)
                }
                mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
            }
        }
    }

    // Initializing UIColor using hex number defined in UIColor extension
//    var colorPalette = [colors: UIColor]()
var colorPalette = [String: UIColor]()
//    enum colors: String {
//        case mountain = "mountain"
//        case grass = "grass"
//        case tree = "tree"
//        case house = "house"
//        case sky = "sky"
//        case river = "river"
//        case road = "road"
//        case stone = "stone"
//        case eraser = "eraser"
//    }
    lazy var color = self.colorPalette["tree"] ?? UIColor(rgb: 0xc3ae95)
    // TODO: Add "brush" feature
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
        let tempImage = AttributedImage()
        tempImage.image = tempImageView.image
        tempImages.append(tempImage)
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
            if points.count >= 2 {
                context.move(to: points[points.count - 2])
                context.addLine(to: points[points.count - 1])
                context.move(to: points[0])
                context.addLine(to: points[1])
            } else {
                tempImage.image = tempImageView.image
                tempImages.append(tempImage)
                tempImageView.image = nil
                points = [CGPoint]()
                return
            }
            context.addPath(computePath(of: points, with: 6))
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
//        path.move(to: points[0])
//        for i in 1..<points.count {
//            path.addLine(to: points[i])
//        }
        return path.cgPath
    }

}

