//
//  UserInfomationEditViewController.swift
//  debuet
//
//  Created by 片平駿介 on 2019/07/09.
//  Copyright © 2019 ShunsukeKatahira. All rights reserved.
//

import UIKit
import Firebase

class UserInfomationEditViewController: UIViewController {
    
    let errormessage = ErrorMessage.self()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // ログアウトボタン押下時
    @IBAction func didClickLogOutBtn(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toTop", sender: nil)
        } catch let error {
            errormessage.showErrorIfNeeded(error)
        }
    }
    
    // アカウント削除ボタン押下時
    @IBAction func didClickAccountDeleteBtn(_ sender: Any) {
        
        Auth.auth().currentUser?.delete() { [weak self] error in
            guard let self = self else { return }
            if error != nil {
                self.performSegue(withIdentifier: "toTop", sender: nil)
            }
            self.errormessage.showErrorIfNeeded(error)
        }
    }
    
}
