//
//  HelpSceneViewController.swift
//  DoddleDo
//
//  Created by Xuzh on 2019/7/23.
//  Copyright © 2019 Xuzh. All rights reserved.
//

import UIKit

class HelpSceneViewController: UIViewController {

    @IBOutlet weak var back: ShadowedImageView! {
        didSet {
            addLongPressGesture(to: back)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    @IBOutlet weak var helpTest: ShadowedImageView! {
        didSet {
            addLongPressGesture(to: helpTest)
        }
    }
}
