//
//  ViewController.swift
//  DoddleDo
//
//  Created by Xuzh on 2019/7/23.
//  Copyright © 2019 Xuzh. All rights reserved.
//

import UIKit
@IBDesignable
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
}

extension UIViewController {

    func addLongPressGesture(to view: UIView) {
        let tapOrPress = UILongPressGestureRecognizer(target: self, action: #selector(buttonTappedOrPressed(recognizer:)))
        tapOrPress.minimumPressDuration = 0
        view.addGestureRecognizer(tapOrPress)
        view.isUserInteractionEnabled = true
    }

    @objc func buttonTappedOrPressed(recognizer: UILongPressGestureRecognizer) {
        switch recognizer.state {
        case .began:
            if let buttonView = recognizer.view as? ShadowedImageView {
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
                        if finished {
                            self.performSegue(withIdentifier: buttonName, sender: nil)
                        }
                    }
                )
            }

        default: break
        }
    }
}
