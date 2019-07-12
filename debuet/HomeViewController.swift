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

// ホーム画面
class HomeViewController: UIViewController {
    
    @IBOutlet weak var targetWeight: UILabel!
    @IBOutlet weak var todayWeightTextField: UITextField!
    @IBOutlet weak var todayBreakfast: CosmosView!
    @IBOutlet weak var todayLunch: CosmosView!
    @IBOutlet weak var todayDinner: CosmosView!
    @IBOutlet weak var lastWeight: UILabel!
    @IBOutlet weak var lastBreakfast: CosmosView!
    @IBOutlet weak var lastLunch: CosmosView!
    @IBOutlet weak var lastDinner: CosmosView!
    
    let db = Firestore.firestore()
    // エラーメッセージ
    let errormessage = ErrorMessage.self()
    // 日付関連クラス
    let dateRelation = DateRelation()
    // TODOを格納するための配列
    var todayRecord:[TodayRecord] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCosmos()
        
        self.navigationItem.hidesBackButton = true
    }
    
    // 記録ボタン押下
    @IBAction func todayRecord(_ sender: Any) {
        
        // 本日の記録処理を呼び出す
        createTodayRecord()
        
    }
}



// Firebase関連処理
extension HomeViewController {
    
    // ユーザ情報登録処理
    func createTodayRecord() {
        
        let now = dateRelation.todayYMDString()
        
        guard ((todayWeightTextField?.text) != nil) else { return }
        
        let todayWeight = todayWeightTextField.text
        let breakfastAmountFood = todayBreakfast.rating
        let lunchAmountFood = todayLunch.rating
        let dinnerAmountFood = todayDinner.rating
        
        // データベースに格納する情報
        let data: [String: Any] = [
            "day": now,
            "weight": todayWeight!,
            "breakfast": breakfastAmountFood,
            "lunch": lunchAmountFood,
            "dinner": dinnerAmountFood
        ]
        
        
        guard let uid = Auth.auth().currentUser?.uid else {
            print("uid is nil")
            return
        }
        
        // アラート用変数定義
        var title = ""
        var message = ""
        let okText = "OK"
        
        // 本日の記録をデータベースに登録
        db.collection("users").document(uid).collection("record").addDocument(data: data) { err in
            if err != nil {
                // エラー発生した場合
                title = "記録できませんでした"
                message = self.errormessage.showErrorIfNeeded(err)
                // アラート処理呼び出す
                self.createAlert(title: title, message: message, okText: okText)
            } else {
                // 登録できた場合
                title = "記録しました"
                message = "記録してくれてありがとう！！"
                // アラート処理呼び出す
                self.createAlert(title: title, message: message, okText: okText)
            }
        }
    }
}

// Cosmos関連処理
extension HomeViewController {
    // 初期表示時
    func setCosmos() {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            print("uid is nil")
            return
        }
        let now = dateRelation.todayYMDString()
        
        todayBreakfast.rating = 0
        todayLunch.rating = 0
        todayDinner.rating = 0
        
        let docRef = db.collection("users").document(uid).collection("record").whereField("day", isEqualTo: now)
        docRef.getDocuments { (docu, error) in
            if error != nil {
                // エラー発生した場合
                print("Error")
                return
            } else {
                for document in docu!.documents {
                    
                    print(document.documentID)
                    self.todayWeightTextField.text = (document.data()["weight"] as! String)
                    self.todayBreakfast.rating = Double(document.data()["breakfast"] as! Int)
                    self.todayLunch.rating = Double(document.data()["lunch"] as! Int)
                    self.todayDinner.rating = Double(document.data()["dinner"] as! Int)
                }
                print(docu!.documents)
            }
        }
        
        // 本日の朝食
        todayBreakfast.settings.minTouchRating = 0
        todayBreakfast.settings.filledImage = UIImage(named: "onigiri1.png")
        todayBreakfast.settings.emptyImage = UIImage(named: "onigiri2.png")
        // 本日の昼食
        todayLunch.settings.minTouchRating = 0
        todayLunch.settings.filledImage = UIImage(named: "onigiri1.png")
        todayLunch.settings.emptyImage = UIImage(named: "onigiri2.png")
        // 本日の夕飯
        todayDinner.settings.minTouchRating = 0
        todayDinner.settings.filledImage = UIImage(named: "onigiri1.png")
        todayDinner.settings.emptyImage = UIImage(named: "onigiri2.png")
        
        // 前回の朝食
        lastBreakfast.settings.updateOnTouch = false
        lastBreakfast.settings.filledImage = UIImage(named: "onigiri1.png")
        lastBreakfast.settings.emptyImage = UIImage(named: "onigiri2.png")
        // 前回の昼食
        lastLunch.settings.updateOnTouch = false
        lastLunch.settings.filledImage = UIImage(named: "onigiri1.png")
        lastLunch.settings.emptyImage = UIImage(named: "onigiri2.png")
        // 前回の夕飯
        lastDinner.settings.updateOnTouch = false
        lastDinner.settings.filledImage = UIImage(named: "onigiri1.png")
        lastDinner.settings.emptyImage = UIImage(named: "onigiri2.png")
    }
}

// アラート関連処理
extension HomeViewController {
    // アラート表示処理
    func createAlert(title: String, message: String, okText: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okayButton = UIAlertAction(title: okText, style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(okayButton)
        self.present(alert, animated: true, completion: nil)
    }
}
