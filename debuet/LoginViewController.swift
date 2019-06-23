//
//  loginViewController.swift
//  debuet
//
//  Created by 片平駿介 on 2019/06/14.
//  Copyright © 2019 ShunsukeKatahira. All rights reserved.
//

import UIKit
import Firebase
import Validator

// ログイン画面
class LoginViewController: UIViewController, Error {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var emailState: UILabel!
    
//    let emailRule = ValidationRulePattern(pattern: EmailValidationPattern.standard, error: ValidationError(message: "エラー"))
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // ログインボタン押下時
    @IBAction func didTapLoginBtn(_ sender: Any) {
       // let emailRule = ValidationRulePattern(pattern: EmailValidationPattern.standard,error: )
        if let email = emailTextField.text, let password = passTextField.text {
            if email != "" && password != "" {
                // email形式でない場合
//                if !(emailRule.validate(input: email)) {
//                    emailState.text = "email形式で入力してください"
//                }
                login(email: email, password: password)
            } else {
                
            }
        }
    }
    
    // viewを押下時にキーボードを閉じる処理
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
