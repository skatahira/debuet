//
//  ProfileCreateViewController.swift
//  debuet
//
//  Created by 片平駿介 on 2019/06/16.
//  Copyright © 2019 ShunsukeKatahira. All rights reserved.
//

import UIKit
import FlexibleSteppedProgressBar

class ProfileCreateViewController: UIViewController {
    
    var progressBar: FlexibleSteppedProgressBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pr()
        
    }
}

// プログレスバー関連処理
extension ProfileCreateViewController: FlexibleSteppedProgressBarDelegate {
    func pr() {
        progressBar = FlexibleSteppedProgressBar()
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(progressBar)
        
        let horizontalConstraint = progressBar.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        let verticalConstraint = progressBar.topAnchor.constraint(
            equalTo: view.topAnchor,
            constant: 80
        )
        
       // let widthConstraint = progressBar.widthAnchor.constraint(equalTo: nil, constant: 500)
        // let widthConstraint = progressBar.widthAnchor.constraintEqualToAnchor(nil, constant: 500)
        //let heightConstraint = progressBar.heightAnchor.constraintEqualToAnchor(nil, constant: 150)
        //NSLayoutConstraint.activateConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        
        // Customise the progress bar here
        progressBar.numberOfPoints = 5
        progressBar.lineHeight = 9
        progressBar.radius = 15
        progressBar.progressRadius = 25
        progressBar.progressLineHeight = 3
        progressBar.delegate = self
    }
    
    func progressBar(_ progressBar: FlexibleSteppedProgressBar,
                     didSelectItemAtIndex index: Int) {
        print("Index selected!")
    }
    
    func progressBar(_ progressBar: FlexibleSteppedProgressBar,
                     willSelectItemAtIndex index: Int) {
        print("Index selected!")
    }
    
    func progressBar(_ progressBar: FlexibleSteppedProgressBar,
                     canSelectItemAtIndex index: Int) -> Bool {
        return true
    }
    
    func progressBar(_ progressBar: FlexibleSteppedProgressBar,
                     textAtIndex index: Int, position: FlexibleSteppedProgressBarTextLocation) -> String {
        //if position == FlexibleSteppedProgressBarTextLocation.BOTTOM {
            switch index {
                
            case 0: return "First"
            case 1: return "Second"
            case 2: return "Third"
            case 3: return "Fourth"
            case 4: return "Fifth"
            default: return "Date"
                
            }
     //   }
        return ""
    }
}
