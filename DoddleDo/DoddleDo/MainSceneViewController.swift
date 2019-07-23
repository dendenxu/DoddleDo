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

    
    @IBOutlet weak var settings: ShadowedImageView!{
        didSet{
            let tap = UITapGestureRecognizer(target: self, action: #selector(openSettings))
            settings.addGestureRecognizer(tap)
            settings.isUserInteractionEnabled = true
        }
    }
    
    @objc func openSettings(){
        performSegue(withIdentifier: "settings", sender: nil)
    }

    
    @IBOutlet weak var help: ShadowedImageView!{
        didSet{
            let tap = UITapGestureRecognizer(target: self, action: #selector(openHelp))
            help.addGestureRecognizer(tap)
            help.isUserInteractionEnabled = true
        }
    }
    
    @objc func openHelp(){
        print("*****Tapped on*****")
        performSegue(withIdentifier: "help", sender: nil)
    }
}

