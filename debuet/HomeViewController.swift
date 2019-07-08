//
//  HomeViewController.swift
//  debuet
//
//  Created by 片平駿介 on 2019/07/05.
//  Copyright © 2019 ShunsukeKatahira. All rights reserved.
//

import UIKit
import Cosmos
import Firebase

class HomeViewController: UIViewController {
    
    @IBOutlet weak var targetWeight: UILabel!
    @IBOutlet weak var todayWeightTextField: UITextField!
    @IBOutlet weak var todayBreakfast: CosmosView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todayBreakfast.rating = 0
        self.navigationItem.hidesBackButton = true
    }

    @IBAction func todayRecord(_ sender: Any) {
        
    }
}
