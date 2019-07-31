//
//  LaunchScreenViewController.swift
//  DoddleDo
//
//  Created by Xuzh on 2019/7/30.
//  Copyright © 2019 Xuzh. All rights reserved.
//

import UIKit

class LaunchScreenViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        performSegue(withIdentifier: "launchScreenSegue", sender: nil)
    }

}
