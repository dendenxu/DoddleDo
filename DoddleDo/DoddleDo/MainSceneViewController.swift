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
            scroller.delegate = self
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

extension UIViewController {

    func addLongPressGesture(to view: UIView) {
        let tapOrPress = UILongPressGestureRecognizer(target: self, action: #selector(buttonTappedOrPressed(recognizer:)))
        tapOrPress.minimumPressDuration = 0
        view.addGestureRecognizer(tapOrPress)
        view.isUserInteractionEnabled = true
    }

    func addTapGesture(to view: UIView) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped(recognizer:)))
        view.addGestureRecognizer(tap)
    }

    @objc func imageTapped(recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            if let buttonView = recognizer.view {
                performSegue(withIdentifier: "doddleBoard", sender: buttonView)
            }
        default: break
        }

    }

    @objc func buttonTappedOrPressed(recognizer: UILongPressGestureRecognizer) {
        switch recognizer.state {
        case .began:
            if let buttonView = recognizer.view {
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
            if let buttonView = recognizer.view as? ShadowedImageView, let buttonName = buttonView.identifier {
                UIView.animate(
                    withDuration: 0.02,
                    delay: 0,
                    usingSpringWithDamping: 0.2,
                    initialSpringVelocity: 0,
                    options: [],
                    animations: {
                        buttonView.transform = CGAffineTransform.identity
                    },
                    completion: {
                        finished in
                        self.performSegue(withIdentifier: buttonName, sender: buttonView)
                    }
                )
            } else if let buttonView = recognizer.view as? ScrollingImageView, let buttonName = buttonView.identifier {
                UIView.animate(
                    withDuration: 0.02,
                    delay: 0,
                    usingSpringWithDamping: 0.2,
                    initialSpringVelocity: 0,
                    options: [],
                    animations: {
                        buttonView.transform = CGAffineTransform.identity
                    },
                    completion: {
                        finished in
                        self.performSegue(withIdentifier: buttonName, sender: buttonView)
                    }
                )
            }
        default: break
        }
    }
}
