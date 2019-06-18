//
//  loginViewController.swift
//  debuet
//
//  Created by 片平駿介 on 2019/06/14.
//  Copyright © 2019 ShunsukeKatahira. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func didTapLoginBtn(_ sender: Any) {
        if let email = emailTextField.text, let password = passTextField.text {
            if email != "" && password != "" {
                login(email: email, password: password)
            }
        }
    }
    
}

extension LoginViewController {
    
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
                self.performSegue(withIdentifier: "toHome", sender: nil)
            }
        }
    }
}
//import UIKit
//import Firebase
//
//class LoginViewController: UIViewController {
//    @IBOutlet weak var emailTextField: UITextField!
//    @IBOutlet weak var passwordTextField: UITextField!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//    }
//
//    @IBAction func didTapLoginBtn(_ sender: Any) {
//        if let email = emailTextField.text, let password = passwordTextField.text {
//            if email != "" && password != "" {
//                login(email: email, password: password)
//            }
//        }
//    }
//
//}
//
//// Firebase関連
//extension LoginViewController {
//    func login(email: String, password: String) {
//        Auth.auth().signIn(withEmail: email, password: password) { (result, err) in
//            if let e = err {
//                print("Fail : \(e)")
//                // 失敗した場合はここで処理終了
//                return
//            }
//            if let r = result {
//                print("Success : \(r.user.email!)")
//                // ログイン成功時に次の画面に遷移
//                self.performSegue(withIdentifier: "toSuccess", sender: nil)
//            }
//        }
//    }
//}
