//
//  RetrySendMailViewController.swift
//  debuet
//
//  Created by 片平駿介 on 2019/07/05.
//  Copyright © 2019 ShunsukeKatahira. All rights reserved.
//

import UIKit
import Firebase

// パスワードリセットメール再送信画面
class RetrySendMailViewController: UIViewController {
    
    @IBOutlet weak var stateLabel: UILabel!
    // 前画面からメールアドレスを受け取る
    var emailText:String = ""
    let errormessage = ErrorMessage.self()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
    }
    
    // 再送信ボタン押下
    @IBAction func didClickSendBtn(_ sender: Any) {
        
        // パスワードリセットメールを送信する
        Auth.auth().sendPasswordReset(withEmail: emailText) { [weak self] error in
            guard self != nil else{ return }
            
            if error == nil {
                self?.stateLabel.text = "メールを再送信しました"
            }
            self?.stateLabel.text = self?.errormessage.showErrorIfNeeded(error)
        }
    }
}
