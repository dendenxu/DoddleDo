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
        if let bouncyUnwindSegue = segue as? BouncyUnwindSegue {
            bouncyUnwindSegue.desinationZoomPoint = backPoint
        }
    }

    override func viewDidLoad() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped(recognizer:)))
        doubleTap.numberOfTapsRequired = 2
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(recognizer:)))
        view.addGestureRecognizer(doubleTap)
        view.addGestureRecognizer(longPress)
    }
    
    @objc func doubleTapped(recognizer: UITapGestureRecognizer) {
        
    }
    
    @objc func longPressed(recognizer: UILongPressGestureRecognizer) {
        
    }
}
