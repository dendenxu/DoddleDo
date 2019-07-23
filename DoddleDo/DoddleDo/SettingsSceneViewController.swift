//
//  SettingsSceneViewController.swift
//  DoddleDo
//
//  Created by Xuzh on 2019/7/23.
//  Copyright © 2019 Xuzh. All rights reserved.
//

import UIKit

class SettingsSceneViewController: UIViewController {

//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBOutlet weak var back: ShadowedImageView!{
        didSet{
            let tap = UITapGestureRecognizer(target: self, action: #selector(goBack))
            back.addGestureRecognizer(tap)
            back.isUserInteractionEnabled = true
        }
    }
    
    @objc func goBack() {
        dismiss(animated: true, completion:{})
    }

    
}
