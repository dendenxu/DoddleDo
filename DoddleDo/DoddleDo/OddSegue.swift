//
//  OddSegue.swift
//  DoddleDo
//
//  Created by Xuzh on 2019/7/27.
//  Copyright © 2019 Xuzh. All rights reserved.
//

import UIKit

class OddSegue: UIStoryboardSegue {

    override func perform() {
        UIView.transition(
            from: source.view,
            to: destination.view,
            duration: 0.25,
            options: .transitionFlipFromBottom,
            completion: nil
        )

        source.present(destination, animated: false, completion: nil)
        source.dismiss(animated: false, completion: nil)
    }
}
