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

    @IBOutlet weak var bottomLine: UILabel! {
        didSet {
            configureBottomLine()
        }
    }

    @IBAction func unwindToMainScene(_ unwindSegue: UIStoryboardSegue) {
        //        let sourceViewController = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
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
                        self.performSegue(withIdentifier: buttonName, sender: buttonView)
//                        if finished {
//                            if buttonName.contains("Back") {
//                                self.dismiss(animated: true, completion: nil)
//                            } else if let destination = self.storyboard?.instantiateViewController(withIdentifier: buttonName) {
//                                self.present(destination, animated: true, completion: nil)
//                            }
//                        }
//                        if finished {
//                            if buttonName.contains("Back") {
//                                self.modalTransitionStyle = .flipHorizontal
//                                self.dismiss(animated: true, completion: nil)
//                            } else {
//                                self.performSegue(withIdentifier: buttonName, sender: buttonView)
//                            }
//                    }
                }
            )
        }
        default: break
    }
}
}
