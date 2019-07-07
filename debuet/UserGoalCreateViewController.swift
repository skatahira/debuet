//
//  UserGoalCreateViewController.swift
//  debuet
//
//  Created by 片平駿介 on 2019/07/03.
//  Copyright © 2019 ShunsukeKatahira. All rights reserved.
//

import UIKit
import Firebase
import FlexibleSteppedProgressBar

// ユーザ目標記録画面
class UserGoalCreateViewController: UIViewController, FlexibleSteppedProgressBarDelegate {
    
    @IBOutlet weak var stepIndicator: FlexibleSteppedProgressBar!
    @IBOutlet weak var goalTextView: UITextView!
    
    var defaultStore : Firestore!
    let db = Firestore.firestore()
    
    // 前画面からユーザ情報を受け取る
    var userInfomation:UserInfomation = UserInfomation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // プログレスバー関連処理呼び出し
        setupStepIndicator()
    }
    
    // 完了ボタン押下時
    @IBAction func didClickDoneBtn(_ sender: Any) {
        
        // ユーザ情報登録処理
        createUserInfomation()
    }
}

// Firebase関連処理
extension UserGoalCreateViewController {
    
    // ユーザ情報登録処理
    func createUserInfomation() {
        
        _ = Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                print("認証済み")
            } else {
                print("認証済みでない")
            }
            
        }
        var ref: DocumentReference? = nil
        
        
        guard goalTextView.text != "" else {
            return
        }
        
        
        // データベースに格納する情報
        let data: [String: Any] = [
            "ニックネーム": userInfomation.userName,
            "年齢": userInfomation.age,
            "誕生日": userInfomation.birth as Any,
            "性別": userInfomation.sex,
            "身体活動レベル": userInfomation.physicalActiveLevel,
            "身長": userInfomation.height,
            "目標": goalTextView.text!,
            "1日の目標食事量": userInfomation.amountOfFood,
            "推奨標準体重": userInfomation.standardWeight,
            "基礎代謝量": userInfomation.basalMetabolicRate,
            "必要推定エネルギー量": userInfomation.requiredEnergy
        ]
        
        // 画像登録処理
        //uploadImage()
        
        ref = db.collection("users").addDocument(data: data) { err in
            if err != nil {
                print("Error adding document")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
        
        performSegue(withIdentifier: "toHome", sender: nil)
    }
    
    // ユーザ画像登録処理
    func uploadImage() {
        // ストレージサービスへの参照を取得
        let storage = Storage.storage()
        // ストレージへの参照を取得
        let storageRef = storage.reference(forURL: "gs://debuet-7732b.appspot.com/")
        // 画像
        let image = userInfomation.userPicture
        let userName = userInfomation.userName
        print("ユーザーネーム\(userName)")
        // imageをNSDataに変換
        let data = image!.jpegData(compressionQuality: 1.0)! as NSData
        // Storageに保存
        storageRef.putData(data as Data, metadata: nil) { (data, error) in
            if error != nil {
                return
            }
        }
        self.dismiss(animated: true, completion: nil)
        
    }
}

// プログレスバー関連処理
extension UserGoalCreateViewController {
    
    // ステップインジケータ表示の初期表示に関するセッティングをするメソッド
    private func setupStepIndicator() {
        stepIndicator.delegate = self
        
        // ステップインジケータの表示数を設定する
        stepIndicator.numberOfPoints = 3
        
        // ステップインジケータの線幅を設定する
        stepIndicator.lineHeight = 4
        
        // ステップインジケータの配色および外枠を設定する
        stepIndicator.selectedOuterCircleLineWidth = 4.0
        stepIndicator.selectedOuterCircleStrokeColor = UIColor.hex(string: "#F9759D", alpha: 1)
        stepIndicator.currentSelectedCenterColor = UIColor.white
        stepIndicator.stepTextColor = UIColor.black
        
        // ステップインディケータのアニメーション秒数を設定する
        stepIndicator.stepAnimationDuration = 0.26
        
        // ステップインジケータの現在位置を設定する
        stepIndicator.currentIndex = 2
    }
    
    //  ステップインジケータを選択した際に実行されるメソッド
    func progressBar(_ progressBar: FlexibleSteppedProgressBar,
                     didSelectItemAtIndex index: Int) {
        print("Index selected!")
        stepIndicator.currentIndex = index
    }
    
    func progressBar(_ progressBar: FlexibleSteppedProgressBar,
                     willSelectItemAtIndex index: Int) {
        print("Index selected!")
    }
    
    // ステップインジケータの選択可否設定するメソッド
    func progressBar(_ progressBar: FlexibleSteppedProgressBar,
                     canSelectItemAtIndex index: Int) -> Bool {
        return false
    }
    
    // ステップインジケータの各ステップの名称を設定
    func progressBar(_ progressBar: FlexibleSteppedProgressBar,
                     textAtIndex index: Int, position: FlexibleSteppedProgressBarTextLocation) -> String {
        if position == FlexibleSteppedProgressBarTextLocation.bottom {
            switch index {
            case 0: return "Step1"
            case 1: return "Step2"
            case 2: return "Step3"
            default: return ""
            }
        }
        return ""
    }
}
