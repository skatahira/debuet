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
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todayBreakfast.rating = 0
        self.navigationItem.hidesBackButton = true
    }

    // 記録ボタン押下
    @IBAction func todayRecord(_ sender: Any) {
        
        
        
        
    }
}


// Firebase関連処理
extension HomeViewController {
    
    // ユーザ情報登録処理
    func createTodayRecord() {
        
        guard ((todayWeightTextField?.text) != nil) else { return }
        
        let todayWeight = todayWeightTextField.text
        
        // データベースに格納する情報
        let data: [String: Any] = [
            "体重": todayWeight!
        ]
        
        
        guard let uid = Auth.auth().currentUser?.uid else {
            print("uid is nil")
            return
        }
        
//        db.collection("users").document(uid).document("record").setData(data) { err in
//            if err != nil {
//                self.resultLabel.text = self.errormessage.showErrorIfNeeded(err)
//                print("ユーザ情報登録失敗！！")
//            } else {
//                print("ユーザ情報登録成功！！")
//                self.performSegue(withIdentifier: "toHome", sender: nil)
//            }
//        }
}
}
