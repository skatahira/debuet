//
//  PassForgetViewController.swift
//  debuet
//
//  Created by 片平駿介 on 2019/07/05.
//  Copyright © 2019 ShunsukeKatahira. All rights reserved.
//

import UIKit
import Firebase
import Validator
import PKHUD

// パスワードリセットメール送信画面
class PassForgetViewController: UIViewController {
    
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var emailState: UILabel!
    @IBOutlet weak var emailCheckLabel: UILabel!
    @IBOutlet weak var errorMessage: UILabel!
    
    
    let errormessage = ErrorMessage.self()
    // バリデーションルールチェック
    let emailRule = ValidationRulePattern(pattern: EmailValidationPattern.standard, error: ValidationErrorType("💩"))
    // ログイン判断フラグ true=可 false=登録不可
    var sendFlg = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // バリデーションチェック
        registerValidationCheck()
        
    }
    
    // メール送信ボタン押下
    @IBAction func didClickSendBtn(_ sender: Any) {
        
        sendFlg = true
        // バリデーションチェック
        didClickBtnValidationCheck()
        
        // 正しい形式で入力されていた場合
        if sendFlg {
            
            let email = mailTextField.text ?? ""
            
            // パスワードリセットメールを送信する
            Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
                guard self != nil else{ return }
                
                if error == nil {
                    self?.performSegue(withIdentifier: "toNext", sender: email)
                }
                self?.errorMessage.text = self?.errormessage.showErrorIfNeeded(error)
            }
        }
    }
    
    // 次画面に渡す値を指定する
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toNext" {
            let retrySendMailViewController = segue.destination as! RetrySendMailViewController
            retrySendMailViewController.emailText = sender as! String
        }
    }
    
    // viewを押下時にキーボードを閉じる処理
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

// バリデーション関連処理
extension PassForgetViewController {
    
    // テキストが変更されたタイミングで実行される入力チェック処理
    func registerValidationCheck() {
        
        // バリデーションルールセット
        mailTextField.validationRules = ValidationRuleSet()
        mailTextField.validationRules?.add(rule: emailRule)
        
        
        // 入力が変更されたタイミングでValidationを有効にする
        mailTextField.validateOnInputChange(enabled: true)
        mailTextField.validationHandler = {
            result in self.updateValidationEmailState(result: result)
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
    
    // アカウント登録バリデーションチェック
    func didClickBtnValidationCheck() {
        if let email = mailTextField.text {
            
            if email == "" {
                emailCheckLabel.text = "メールアドレスを入力してください"
                sendFlg = false
            } else if emailState.text == "💩" {
                emailCheckLabel.text = "メールアドレス形式で入力してください"
                sendFlg = false
            }
        }
    }
}

