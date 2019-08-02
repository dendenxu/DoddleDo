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

    @IBOutlet weak var scroller: UIScrollView! {
        didSet {
            scroller.delegate = self
            scroller.canCancelContentTouches = true
            if let subView = scroller.subviews.first as? UIStackView { // first subview is the stack view that contains the subviews
                scroller.contentSize = subView.frame.size
                for image in subView.subviews {
                    if let image = image as? ScrollingView {
                        addImageTappedGestureRecognizer(to: image)
                    }
                }
            }

        }
    }

    // TODO: Add scrolling effect
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

    }


    @IBAction func unwindToMainScene(_ unwindSegue: UIStoryboardSegue) { }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let bouncySegue = segue as? BouncySegue, let identifier = bouncySegue.identifier, identifier == "doddleBoard" {
//            if let recognizer = sender as? UITapGestureRecognizer {
//                bouncySegue.desinationZoomPoint = recognizer.location(in: nil)
//            }
            if let location = sender as? CGPoint, let doddleBoard = segue.destination as? DoddleBoardViewController {
                bouncySegue.desinationZoomPoint = location
                doddleBoard.backPoint = location
            }
        }
    }
}

extension MainSceneViewController {
    private struct constants {
        static let bottomLineFontSize: CGFloat = 25
        static let bottomLineKern: CGFloat = 2
    }
}

extension UIViewController {

    func addButtonTappedOrPressedGestureRecognizer(to view: ShadowedImageView) {
        let tapOrPress = UILongPressGestureRecognizer(target: self, action: #selector(buttonTappedOrPressed(recognizer:)))
        tapOrPress.minimumPressDuration = 0
        view.addGestureRecognizer(tapOrPress)
        view.isUserInteractionEnabled = true
    }

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

    @objc func buttonTappedOrPressed(recognizer: UILongPressGestureRecognizer) {
        switch recognizer.state {
        case .changed: fallthrough
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
        case .began:
            if let view = recognizer.view {
                if let view = view as? ShadowedImageView, let name = view.identifier, name == "settings" {
                    let rotation = CABasicAnimation(keyPath: "transform.rotation")
                    rotation.fromValue = 0
                    rotation.toValue = constants.settingsRotationAngle
                    rotation.duration = constants.settingsRotationDuration
                    rotation.autoreverses = true
                    view.layer.add(rotation, forKey: nil)
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
//            view = recognizer.view as? ScrollingImageView ?? view
            let name: String? = (view as? ShadowedImageView)?.identifier
//            name = (view as? ScrollingImageView)?.identifier ?? name

            if let name = name, let view = view {
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
                        self.performSegue(withIdentifier: name, sender: recognizer)
                    }
                )
            }
        default: break
        }
    }
}


extension UIViewController {
    private struct constants {
        static let imageTappedAnimationDuration: Double = 0.1
        static let imageTappedTransformScale: CGFloat = 1.1
        static let buttonTappedOrPressedAnimationDuration: Double = 0.06
        static let buttonTappedOrPressedSpringDamping: CGFloat = 0.2
        static let buttonTappedOrPressedTransformScale: CGFloat = 1.2
        static let settingsRotationAngle = CGFloat.pi/4
        static let settingsRotationDuration: Double = 0.5
    }
}
