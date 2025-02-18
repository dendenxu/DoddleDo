//
//  ViewController.swift
//  DoddleDo
//
//  Created by Xuzh on 2019/7/23.
//  Copyright © 2019 Xuzh. All rights reserved.
//

import UIKit


@IBDesignable
class MainSceneViewController: UIViewController, UIScrollViewDelegate {

    @IBAction func unwindToMainScene(_ unwindSegue: UIStoryboardSegue) { }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let bouncySegue = segue as? BouncySegue, let location = sender as? CGPoint {
            bouncySegue.desinationZoomPoint = location
            if let doddleBoard = segue.destination as? DoddleBoardViewController {
                doddleBoard.backPoint = location
            } else if let settings = segue.destination as? SettingsSceneViewController {
                settings.backPoint = location
            } else if let help = segue.destination as? HelpSceneViewController {
                help.backPoint = location
            }
        }
    }

    @IBOutlet weak var settings: ShadowedImageView! {
        didSet {
            addButtonTappedOrPressedGestureRecognizer(to: settings)
        }
    }

    @IBOutlet weak var help: ShadowedImageView! {
        didSet {
            addButtonTappedOrPressedGestureRecognizer(to: help)
        }
    }

    @IBOutlet weak var bottomLine: UILabel! {
        didSet {
            configureBottomLine()
        }
    }

    private func configureBottomLine() {
        if let text = bottomLine.text {
            let font = UIFont.boldSystemFont(ofSize: constants.bottomLineFontSize)
            let attributes: [NSAttributedString.Key: Any] = [
                    .foregroundColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1),
                    .font: font,
                    .kern: constants.bottomLineKern
            ]
            let attributedText = NSAttributedString(string: text, attributes: attributes)
            bottomLine.attributedText = attributedText
            bottomLine.frame.size = CGSize.zero
            bottomLine.sizeToFit()
        }
    }

    @IBOutlet weak var scrollingViewHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollingViewWidth: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        scroller.delegate = self
        scroller.canCancelContentTouches = true
        scrollingViewHeight.constant = UIView.constants.screenHeight * constants.scrollingViewScale
        scrollingViewWidth.constant = UIView.constants.screenWidth * constants.scrollingViewScale
        if let subView = scroller.subviews.first as? UIStackView { // first subview is the stack view that contains the subviews
            for image in subView.subviews {
                addImageTappedGestureRecognizer(to: image as! ScrollingView)
            }
            scroller.contentSize = subView.frame.size
        }
    }

    @IBOutlet weak var scroller: UIScrollView!
    func addImageTappedGestureRecognizer(to view: ScrollingView) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped(recognizer:)))
        view.addGestureRecognizer(tap)
    }

    @objc func imageTapped(recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            let tempLocation = recognizer.location(in: self.view)
            UIView.animateKeyframes(
                withDuration: constants.imageTappedAnimationDuration,
                delay: 0,
                options: [],
                animations: {
                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                        recognizer.view?.transform = CGAffineTransform.identity.scaledBy(x: constants.imageTappedTransformScale, y: constants.imageTappedTransformScale)
                    }
                    UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                        recognizer.view?.transform = CGAffineTransform.identity
                    }
                },
                completion: { finished in
                    self.performSegue(withIdentifier: "doddleBoard", sender: tempLocation)
                }
            )
        default: break
        }
    }

    // TODO: Add 3D effect
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

    }
}

extension UIViewController {

    func addButtonTappedOrPressedGestureRecognizer(to view: ShadowedImageView) {
        let tapOrPress = UILongPressGestureRecognizer(target: self, action: #selector(buttonTappedOrPressed(recognizer:)))
        tapOrPress.minimumPressDuration = 0
        tapOrPress.delegate = self as? UIGestureRecognizerDelegate
        view.addGestureRecognizer(tapOrPress)
        view.isUserInteractionEnabled = true
    }

    @objc func buttonTappedOrPressed(recognizer: UILongPressGestureRecognizer) {
        switch recognizer.state {
        case .cancelled: fallthrough
        case .failed:
            UIView.animate(
                withDuration: constants.buttonTappedOrPressedAnimationDuration,
                delay: 0,
                usingSpringWithDamping: constants.buttonTappedOrPressedSpringDamping,
                initialSpringVelocity: 0,
                options: [],
                animations: {
                    recognizer.view?.transform = CGAffineTransform.identity
                }
            )
            return
        case .began:
            if let view = recognizer.view {
                // MARK: helpTest is deprecated
                if let view = view as? ShadowedImageView, let name = view.identifier, name == "settings" || name == "help" || name == "helpTest" {
                    let rotation = CABasicAnimation(keyPath: "transform.rotation")
                    rotation.fromValue = 0
                    rotation.toValue = constants.settingsRotationAngle
                    let shadowWidth = CAKeyframeAnimation(keyPath: "shadowOffset.width")
                    shadowWidth.values = [4, 5.6, 4, 0, -4, -5.6, -4, 0, 4]
                    shadowWidth.keyTimes = [0.0, 0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.825, 1.0]
                    let shadowHeight = CAKeyframeAnimation(keyPath: "shadowOffset.height")
                    shadowHeight.values = [4, 0, -4, -5.6, -4, 0, 4, 5.6, 4]
                    shadowHeight.keyTimes = [0.0, 0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.825, 1.0]
                    let group = CAAnimationGroup()
                    group.animations = [rotation, shadowWidth, shadowHeight]
                    group.duration = constants.settingsRotationDuration
                    group.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
                    view.layer.add(group, forKey: nil)
                }
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
            let view: UIView? = recognizer.view as? ShadowedImageView
            let name: String? = (view as? ShadowedImageView)?.identifier

            if let name = name, let view = view {
                let tempLocation = recognizer.location(in: self.view)
                UIView.animate(
                    withDuration: constants.buttonTappedOrPressedAnimationDuration,
                    delay: 0,
                    usingSpringWithDamping: constants.buttonTappedOrPressedSpringDamping,
                    initialSpringVelocity: 0,
                    options: [],
                    animations: {
                        view.transform = CGAffineTransform.identity
                    },
                    completion: {
                        finished in
                        if let viewController = self as? DoddleBoardViewController {
                            if viewController.colorPalette[name] != nil {
                                viewController.brush = name
                                viewController.color = viewController.colorPalette[name]!
                                viewController.brushWidth = viewController.brushWidthPalette[name]!
                            } else if name == "boardBack" {
                                self.performSegue(withIdentifier: name, sender: tempLocation)
                            }
                        } else {
                            self.performSegue(withIdentifier: name, sender: tempLocation)
                        }
                    }
                )
            }
        default: break
        }
    }

    struct constants {
        static let imageTappedAnimationDuration: Double = 0.1
        static let imageTappedTransformScale: CGFloat = 1.1
        static let buttonTappedOrPressedAnimationDuration: Double = 0.06
        static let buttonTappedOrPressedSpringDamping: CGFloat = 0.2
        static let buttonTappedOrPressedTransformScale: CGFloat = 1.2
        static let settingsRotationAngle = CGFloat.pi * 2
        static let settingsRotationDuration: Double = 0.8
    }
}


extension MainSceneViewController {
    private struct constants {
        static let bottomLineFontSize: CGFloat = 25
        static let bottomLineKern: CGFloat = 2
        static let scrollingViewScale: CGFloat = 0.377
    }
}
