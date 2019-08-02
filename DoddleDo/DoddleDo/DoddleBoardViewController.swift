//
//  DoddleBoardViewController.swift
//  DoddleDo
//
//  Created by Xuzh on 2019/8/1.
//  Copyright © 2019 Xuzh. All rights reserved.
//

import UIKit

class DoddleBoardViewController: UIViewController {
    @IBOutlet weak var back: ShadowedImageView! {
        didSet {
            addButtonTappedOrPressedGestureRecognizer(to: back)
        }
    }
    
    var backPoint = CGPoint()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let bouncyUnwindSegue = segue as? BouncyUnwindSegue, let identifier = bouncyUnwindSegue.identifier, identifier == "boardBack" {
            bouncyUnwindSegue.desinationZoomPoint = backPoint
        }
    }
}
