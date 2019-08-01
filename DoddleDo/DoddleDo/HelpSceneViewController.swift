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
            addLongPressGesture(to: back)
        }
    }
    
    @IBOutlet weak var helpTest: ShadowedImageView! {
        didSet {
            addLongPressGesture(to: helpTest)
        }
    }
    
    @IBAction func unwindToGoBack(_ unwindSegue: UIStoryboardSegue) {
//        let sourceViewController = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
    }
    
//    @IBAction func returnFromSegueActions(sender: UIStoryboardSegue) {
//
//    }
//
//    override func segueForUnwinding(to toViewController: UIViewController, from fromViewController: UIViewController, identifier: String?) -> UIStoryboardSegue? {
//        if let id = identifier{
//            if id == "customUnwindSegue" {
//                let unwindSegue = CustomUnwindSegue(identifier: id, source: fromViewController, destination: toViewController, performHandler: { () -> Void in
//
//                })
//                return unwindSegue
//            }
//        }
//
//        return super.segueForUnwinding(to: toViewController, from: fromViewController, identifier: identifier)
//    }
}
