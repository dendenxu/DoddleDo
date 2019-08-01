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
            addLongPressGesture(to: back)
        }
    }
}
