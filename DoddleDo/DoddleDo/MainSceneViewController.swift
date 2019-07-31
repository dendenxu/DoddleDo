//
//  ViewController.swift
//  DoddleDo
//
//  Created by Xuzh on 2019/7/23.
//  Copyright © 2019 Xuzh. All rights reserved.
//

import UIKit
@IBDesignable
class MainSceneViewController: VCLLoggingViewController {

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

extension VCLLoggingViewController {

    var backInTheHeap:UIViewController? {
        get {
            return parent
        }
        set {
            setValue(newValue, forKey: "parent")
        }
    }
    
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
                            if let presenting = self.damnIt, buttonName.contains("Back") {
                                print("Before transition and animation")
                                UIView.transition(
                                    from: self.view,
                                    to: presenting.view,
                                    duration: 0.25,
                                    options: .transitionFlipFromBottom,
                                    completion: {
                                        finished in
                                        print("After animation")
//                                        self.removeFromParent()
                                        self.dismiss(animated: false, completion: nil)
                                    }
                                )
                                print("After transition")
                            } else {
                                if let destination = self.storyboard?.instantiateViewController(withIdentifier: buttonName) {
                                    UIView.transition(
                                        from: self.view,
                                        to: destination.view,
                                        duration: 0.25,
                                        options: .transitionFlipFromBottom,
                                        completion: {
                                            finished in
                                            
                                            self.present(destination, animated: false, completion: nil)
                                            (destination as? VCLLoggingViewController)?.damnIt = self
//                                            self.addChild(destination)
//                                            self.view.addSubview(destination.view)
                                        }
                                    )
                                }
                            }
                        }
                    }
                )
            }
        default: break
        }
    }
}
