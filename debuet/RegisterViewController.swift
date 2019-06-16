//
//  RegisterViewController.swift
//  debuet
//
//  Created by 片平駿介 on 2019/06/14.
//  Copyright © 2019 ShunsukeKatahira. All rights reserved.
//

import UIKit
import Firebase

// 新規登録画面
class RegisterViewController: UIViewController {

    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var morePasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // アカウント登録ボタン押下時
    @IBAction func didTapRegisterBtn(_ sender: Any) {
        
        if let email = mailTextField.text,
            let password = passwordTextField.text,
            let password2 =  morePasswordTextField.text {
            // 空文字チェック
            if email != "" && password != "" && password2 != "" {
                // パスワードチェック
                if password == password2 {
                    register(email: email, password: password)
                }
            }
            
        }
    }
}

// Firebase関連処理
extension RegisterViewController {
    // ユーザ登録機能
    func register(email: String, password: String) {
        // Firebaseの認証機能にユーザー登録処理があるのでそれを利用
        // メールアドレスとパスワードを渡すだけ
        Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
            if let e = err {
                print("Fail : \(e)")
            }
            if let r = result {
                print("Success : \(r.user.email!)")
                self.performSegue(withIdentifier: "toUserInfomation1", sender: nil)
            }
        }
    }
}
