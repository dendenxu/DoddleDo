//
//  ViewController.swift
//  DoddleDo
//
//  Created by Xuzh on 2019/7/23.
//  Copyright © 2019 Xuzh. All rights reserved.
//

import UIKit


@IBDesignable
//class MainSceneViewController: UIViewController, UIScrollViewDelegate {
class MainSceneViewController: UIViewController {
    @IBOutlet weak var settings: ShadowedImageView! {
        didSet {
            addLongPressGesture(to: settings)
        }
    }

    @IBOutlet weak var help: ShadowedImageView! {
        didSet {
            addLongPressGesture(to: help)
        }
    }

    @IBOutlet weak var bottomLine: UILabel! {
        didSet {
            configureBottomLine()
        }
    }

    private func configureBottomLine() {
        if let text = bottomLine.text {
            let font = UIFont.preferredFont(forTextStyle: .caption2).withSize(25.0)
            let attributes: [NSAttributedString.Key: Any] = [
                    .foregroundColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1),
                    .font: font,
                    .kern: 2.0
            ]
            let attributedText = NSAttributedString(string: text, attributes: attributes)
            bottomLine.attributedText = attributedText
            bottomLine.frame.size = CGSize.zero
            bottomLine.sizeToFit()
        }
    }

    @IBOutlet weak var scroller: UIScrollView! {
        didSet {
//            scroller.delegate = self
            scroller.canCancelContentTouches = true
            if let subView = scroller.subviews.first {
                scroller.contentSize = subView.frame.size
                for image in subView.subviews {
                    addTapGesture(to: image)
                }
            }

        }
    }


    @IBAction func unwindToMainScene(_ unwindSegue: UIStoryboardSegue) { }
}

//extension ScrollingImageView {
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        UIView.animate(
//            withDuration: 0.02,
//            delay: 0,
//            usingSpringWithDamping: 0.2,
//            initialSpringVelocity: 0,
//            options: [],
//            animations: {
//                self.transform = CGAffineTransform.identity.scaledBy(x: 1.1, y: 1.1)
//            }
//        )
//    }
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        UIView.animate(
//            withDuration: 0.02,
//            delay: 0,
//            usingSpringWithDamping: 0.2,
//            initialSpringVelocity: 0,
//            options: [],
//            animations: {
//                self.transform = CGAffineTransform.identity
//            }
//        )
//    }
    
//}

extension UIViewController: CAAnimationDelegate, UIGestureRecognizerDelegate {

//    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        if (otherGestureRecognizer.isKind(of: UIPanGestureRecognizer.self)) && gestureRecognizer.isKind(of: UILongPressGestureRecognizer.self) {
//            return true
//        } else {
//            return false
//        }
//    }
//
//    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return true
//    }

    func addLongPressGesture(to view: UIView) {
        let tapOrPress = UILongPressGestureRecognizer(target: self, action: #selector(buttonTappedOrPressed(recognizer:)))
//        tapOrPress.delegate = self
//        tapOrPress.cancelsTouchesInView = false
//        tapOrPress.allowableMovement = 3
        tapOrPress.minimumPressDuration = 0
        view.addGestureRecognizer(tapOrPress)
        view.isUserInteractionEnabled = true
    }

    func addTapGesture(to view: UIView) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped(recognizer:)))
        view.addGestureRecognizer(tap)
//        let tapOrPress = UILongPressGestureRecognizer(target: self, action: #selector(imageTapped(recognizer:)))
//        tapOrPress.minimumPressDuration = 0
//        view.addGestureRecognizer(tapOrPress)
//        view.isUserInteractionEnabled = true
    }

    @objc func imageTapped(recognizer: UIGestureRecognizer) {
        switch recognizer.state {
//        case .began:
//            let pulse = CABasicAnimation(keyPath: "transform.scale")
//            pulse.fromValue = 1
//            pulse.toValue = 1.1
//            pulse.duration = 0.02
//            pulse.isRemovedOnCompletion = false
//            pulse.fillMode = .backwards
//            recognizer.view?.layer.add(pulse, forKey: nil)
        case .began: fallthrough
        case .possible:
            UIView.animate(
                withDuration: 0.02,
                delay: 0,
                usingSpringWithDamping: 0.2,
                initialSpringVelocity: 0,
                options: [],
                animations: {
                    recognizer.view?.transform = CGAffineTransform.identity.scaledBy(x: 1.1, y: 1.1)
                }
            )
        case .cancelled: fallthrough
        case .failed:
            UIView.animate(
                withDuration: 0.02,
                delay: 0,
                usingSpringWithDamping: 0.2,
                initialSpringVelocity: 0,
                options: [],
                animations: {
                    recognizer.view?.transform = CGAffineTransform.identity
                }
            )
        case .ended:
//            recognizer.view?.layer.transform = CATransform3DMakeScale(1.1, 1.1, 1)
//            recognizer.view?.layer.removeAllAnimations()
            UIView.animate(
                withDuration: 0.02,
                delay: 0,
                usingSpringWithDamping: 0.2,
                initialSpringVelocity: 0,
                options: [],
                animations: {
                    recognizer.view?.transform = CGAffineTransform.identity
                },
                completion: { finished in
                    self.performSegue(withIdentifier: "doddleBoard", sender: recognizer.view)
                }
            )

//            recognizer.view?.layer.transform = CATransform3DIdentity
        default: break
        }
    }

    @objc func buttonTappedOrPressed(recognizer: UILongPressGestureRecognizer) {
        switch recognizer.state {
        case .changed: fallthrough
        case .cancelled: fallthrough
        case .failed:
//            print("Cancelled or failed")
            UIView.animate(
                withDuration: 0.02,
                delay: 0,
                usingSpringWithDamping: 0.2,
                initialSpringVelocity: 0,
                options: [],
                animations: {
                    recognizer.view?.transform = CGAffineTransform.identity
                }
            )
        case .began:
//            print("Began")
            if let buttonView = recognizer.view {
                if let buttonImageView = buttonView as? ShadowedImageView, let buttonName = buttonImageView.identifier, buttonName == "settings" {
                    let rotation = CABasicAnimation(keyPath: "transform.rotation")
                    rotation.fromValue = 0
                    rotation.toValue = CGFloat.pi / 4
                    rotation.duration = 0.5
                    buttonImageView.layer.add(rotation, forKey: nil)
                }
                UIView.animate(
                    withDuration: 0.02,
                    delay: 0,
                    usingSpringWithDamping: 0.2,
                    initialSpringVelocity: 0,
                    options: [],
                    animations: {
                        buttonView.transform = CGAffineTransform.identity.scaledBy(x: 1.2, y: 1.2)
                    }
                )
            }
        case .ended:
//            print("Ended")
            var name: String?
            var view: UIView?
            if let buttonView = recognizer.view as? ShadowedImageView, let buttonName = buttonView.identifier {
                name = buttonName
                view = buttonView
            } else if let buttonView = recognizer.view as? ScrollingImageView, let buttonName = buttonView.identifier {
                name = buttonName
                view = buttonView
            }
            if let name = name, let view = view {
                UIView.animate(
                    withDuration: 0.02,
                    delay: 0,
                    usingSpringWithDamping: 0.2,
                    initialSpringVelocity: 0,
                    options: [],
                    animations: {
                        view.transform = CGAffineTransform.identity
                    },
                    completion: {
                        finished in
                        self.performSegue(withIdentifier: name, sender: view)
                    }
                )
            }
        default: break
        }
    }
}
