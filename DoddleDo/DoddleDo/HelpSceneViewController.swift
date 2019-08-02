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
    
}
