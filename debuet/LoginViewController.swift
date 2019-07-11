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
    @IBOutlet weak var passwordState: UILabel!
    @IBOutlet weak var emailCheckLabel: UILabel!
    @IBOutlet weak var passwordCheckLabel: UILabel!
    @IBOutlet weak var errorState: UILabel!
    
    // バリデーションチェックルール
    let lengthRule = ValidationRuleLength(min: 8, max: 128, error: ValidationErrorType("💩"))
    let emailRule = ValidationRulePattern(pattern: EmailValidationPattern.standard, error: ValidationErrorType("💩"))
    
    let errormessage = ErrorMessage.self()
    // ログイン判断フラグ true=可 false=登録不可
    var loginFlg = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerValidationCheck()
        
    }
    
    // ログインボタン押下時
    @IBAction func didTapLoginBtn(_ sender: Any) {
        
        loginFlg = true
        didClickBtnValidationCheck()
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
                self.errorState.text = self.errormessage.showErrorIfNeeded(e)
                // 失敗した場合は処理終了
                return
            }
            if let r = result {
                print("Success : \(r.user.email!)")
                
                let user = Auth.auth().currentUser
                let userRef = Firestore.firestore().collection("users").document(user!.uid)
                
                userRef.getDocument { (document, error) in
                    // 画面遷移判断
                    if let document = document, document.exists {
                        // ユーザ情報登録完了している場合
                        self.performSegue(withIdentifier: "toHome", sender: nil)
                    } else {
                        // ユーザ情報登録をしていない場合
                        self.performSegue(withIdentifier: "toCreate", sender: nil)
                    }
                }
            }
            
        }
    }
}

// バリデーション関連処理
extension LoginViewController {
    
    // テキストが変更されたタイミングで実行される入力チェック処理
    func registerValidationCheck() {
        
        // バリデーションルールセット
        emailTextField.validationRules = ValidationRuleSet()
        emailTextField.validationRules?.add(rule: emailRule)
        passTextField.validationRules = ValidationRuleSet()
        passTextField.validationRules?.add(rule: lengthRule)
        
        // 入力が変更されたタイミングでValidationを有効にする
        emailTextField.validateOnInputChange(enabled: true)
        emailTextField.validationHandler = {
            result in self.updateValidationEmailState(result: result)
        }
        passTextField.validateOnInputChange(enabled: true)
        passTextField.validationHandler = {
            result in self.updateValidationPassState(result: result)
        }
    }
    
    // email形式チェック
    func updateValidationEmailState(result: ValidationResult) {
        emailCheckLabel.text = ""
        switch result {
        case .valid:
            emailState.text = "😎"
        case .invalid(let failures):
            emailState.text = (failures.first as? ValidationErrorType)?.message
        }
    }
    
    // パスワード文字数チェック
    func updateValidationPassState(result: ValidationResult) {
        passwordCheckLabel.text = ""
        switch result {
        case .valid:
            passwordState.text = "😎"
        case .invalid(let failures):
            passwordState.text = (failures.first as? ValidationErrorType)?.message
        }
    }
    
    // アカウント登録バリデーションチェック
    func didClickBtnValidationCheck() {
        if let email = emailTextField.text, let password = passTextField.text {
            
            if email == "" {
                emailCheckLabel.text = "メールアドレスを入力してください"
                loginFlg = false
            } else if emailState.text == "💩" {
                emailCheckLabel.text = "メールアドレス形式で入力してください"
                loginFlg = false
            }
            if password == "" {
                passwordCheckLabel.text = "パスワードを入力してください"
                loginFlg = false
            } else if passwordState.text == "💩" {
                passwordCheckLabel.text = "8文字以上入力してください"
                loginFlg = false
            }
            // ログイン判断
            if loginFlg {
                login(email: email, password: password)
            }
        }
    }
}
