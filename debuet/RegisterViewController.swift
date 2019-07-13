//
//  RegisterViewController.swift
//  debuet
//
//  Created by 片平駿介 on 2019/06/14.
//  Copyright © 2019 ShunsukeKatahira. All rights reserved.
//

import UIKit
import Firebase
import Validator

// アカウント登録画面
class RegisterViewController: UIViewController {
    
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var morePasswordTextField: UITextField!
    @IBOutlet weak var emailState: UILabel!
    @IBOutlet weak var passwordState: UILabel!
    @IBOutlet weak var morePasswordState: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var emailCheckLabel: UILabel!
    @IBOutlet weak var passwordCheckLabel: UILabel!
    @IBOutlet weak var morePasswordCheckLabel: UILabel!
    
    // バリデーションチェックルール
    let lengthRule = ValidationRuleLength(min: 8, max: 128, error: ValidationErrorType("💩"))
    let emailRule = ValidationRulePattern(pattern: EmailValidationPattern.standard, error: ValidationErrorType("💩"))
    // 登録判断フラグ true=可 false=登録不可
    var registerFlg = true
    
    let errormessage = ErrorMessage.self()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 入力チェック処理呼び出し
        registerValidationCheck()
    }
    
    // アカウント登録ボタン押下時
    @IBAction func didTapRegisterBtn(_ sender: Any) {
        
        registerFlg = true
        // バリデーションチェック
        didClickBtnValidationCheck()
    }
    
    // viewを押下時にキーボードを閉じる処理
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

// Firebase関連処理
extension RegisterViewController {
    // ユーザ登録機能
    func register(email: String, password: String) {
        // Firebaseの認証機能にユーザー登録処理があるのでそれを利用
        // メールアドレスとパスワードを渡すだけ
        Auth.auth().createUser(withEmail: email, password: password) { (user, err) in
            
            if let e = err {
                self.resultLabel.text = self.errormessage.showErrorIfNeeded(e)
                print("Fail : \(e)")
            }
            if let user = user {
                print("Success : \(user.user.email!)")                
                self.performSegue(withIdentifier: "toUserInfomation1", sender: user)
            }
        }
    }
}

// バリデーション関連処理
extension RegisterViewController {
    
    // テキストが変更されたタイミングで実行される入力チェック処理
    func registerValidationCheck() {
        
        // バリデーションルールセット
        mailTextField.validationRules = ValidationRuleSet()
        mailTextField.validationRules?.add(rule: emailRule)
        passwordTextField.validationRules = ValidationRuleSet()
        passwordTextField.validationRules?.add(rule: lengthRule)
        morePasswordTextField.validationRules = ValidationRuleSet()
        morePasswordTextField.validationRules?.add(rule: lengthRule)
        
        // 入力が変更されたタイミングでValidationを有効にする
        mailTextField.validateOnInputChange(enabled: true)
        mailTextField.validationHandler = {
            result in self.updateValidationEmailState(result: result)
        }
        passwordTextField.validateOnInputChange(enabled: true)
        passwordTextField.validationHandler = {
            result in self.updateValidationPassState(result: result)
        }
        morePasswordTextField.validateOnInputChange(enabled: true)
        morePasswordTextField.validationHandler = {
            result in self.updateValidationMorePassState(result: result)
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
    
    // パスワード(もう一度)文字数チェック
    func updateValidationMorePassState(result: ValidationResult) {
        morePasswordCheckLabel.text = ""
        switch result {
        case .valid:
            morePasswordState.text = "😎"
        case .invalid(let failures):
            morePasswordState.text = (failures.first as? ValidationErrorType)?.message
        }
    }
    
    // アカウント登録バリデーションチェック
    func didClickBtnValidationCheck() {
        
        if let email = mailTextField.text,
            let password = passwordTextField.text,
            let password2 =  morePasswordTextField.text {
            
            // 空文字チェック
            if email == "" {
                emailCheckLabel.text = "メールアドレスを入力してください"
                registerFlg = false
            } else if emailState.text == "💩" {
                emailCheckLabel.text = "メールアドレス形式で入力してください"
                registerFlg = false
            }
            if password == "" {
                passwordCheckLabel.text = "パスワードを入力してください"
                registerFlg = false
            } else if passwordState.text == "💩" {
                passwordCheckLabel.text = "8文字以上入力してください"
                registerFlg = false
            }
            if password2 == "" {
                morePasswordCheckLabel.text = "パスワードを入力してください"
                registerFlg = false
            } else if morePasswordState.text == "💩" {
                morePasswordCheckLabel.text = "8文字以上入力してください"
                registerFlg = false
            }
            // パスワード一致チェック
            if password != password2 {
                resultLabel.text = "同じパスワードを入力してください"
                registerFlg = false
            }
            // アカウント登録判断
            if registerFlg {
                register(email: email, password: password)
            }
        }
    }
}
