//
//  HelpSceneViewController.swift
//  DoddleDo
//
//  Created by Xuzh on 2019/7/23.
//  Copyright © 2019 Xuzh. All rights reserved.
//

import UIKit


@IBDesignable
class HelpSceneViewController: UIViewController {

    @IBOutlet weak var back: ShadowedImageView! {
        didSet {
            addButtonTappedOrPressedGestureRecognizer(to: back)
        }
    }

    @IBOutlet weak var helpTest: ShadowedImageView! {
        didSet {
            addButtonTappedOrPressedGestureRecognizer(to: helpTest)
        }
    }

    @IBAction func unwindToGoBack(_ unwindSegue: UIStoryboardSegue) { }

    var backPoint = CGPoint()

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let bouncyUnwindSegue = segue as? BouncyUnwindSegue {
            bouncyUnwindSegue.desinationZoomPoint = backPoint
        } else if let bouncySegue = segue as? BouncySegue, let location = sender as? CGPoint {
            bouncySegue.desinationZoomPoint = location
            if let help = segue.destination as? HelpSceneViewController {
                help.backPoint = location
            }
        }
    }
}
