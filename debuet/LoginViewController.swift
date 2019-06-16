//
//  loginViewController.swift
//  debuet
//
//  Created by 片平駿介 on 2019/06/14.
//  Copyright © 2019 ShunsukeKatahira. All rights reserved.
//

import UIKit
import Firebase

class loginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension loginViewController {
    
    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, err) in
            if let e = err {
                print("Fail : \(e)")
                // 失敗した場合はここで処理終了
                return
            }
            if let r = result {
                print("Success : \(r.user.email!)")
                // ログイン成功時に次の画面に遷移
                self.performSegue(withIdentifier: "toTop", sender: nil)
            }
        }
    }
}
