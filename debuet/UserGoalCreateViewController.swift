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
    import PKHUD
    
    // ユーザ目標記録画面
    class UserGoalCreateViewController: UIViewController, FlexibleSteppedProgressBarDelegate {
        
        @IBOutlet weak var stepIndicator: FlexibleSteppedProgressBar!
        @IBOutlet weak var goalTextView: UITextView!
        @IBOutlet weak var resultLabel: UILabel!
        
        var defaultStore : Firestore!
        let db = Firestore.firestore()
        
        // エラーメッセージ
        let errormessage = ErrorMessage.self()
        
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
            HUD.show(.progress)
            
            guard goalTextView.text != "" else {
                return
            }
            
            // データベースに格納する情報
            let data: [String: Any] = [
                // ニックネーム
                "nickName": userInfomation.userName,
                // 年齢
                "age": userInfomation.age,
                // 誕生日
                "birth": userInfomation.birth as Any,
                // 性別
                "sex": userInfomation.sex,
                // 身体活動レベル
                "physicalActiveLevel": userInfomation.physicalActiveLevel,
                // 身長
                "height": userInfomation.height,
                // 目標
                "goalText": goalTextView.text!,
                // 1日の目標食事量
                "oneDayAmountOfFood": userInfomation.amountOfFood,
                // 推奨標準体重
                "standardWeight": userInfomation.standardWeight,
                // 基礎代謝量
                "basalMetabolicRate": userInfomation.basalMetabolicRate,
                // 必要推定エネルギー
                "requiredEnergy": userInfomation.requiredEnergy
            ]
            
            
            guard let uid = Auth.auth().currentUser?.uid else {
                HUD.hide()
                print("uid is nil")
                return
            }
            // 画像登録処理
            uploadImage(uid: uid)
            
            db.collection("users").document(uid).setData(data) { err in
                if err != nil {
                    self.resultLabel.text = self.errormessage.showErrorIfNeeded(err)
                    print("ユーザ情報登録失敗！！")
                    HUD.hide()
                    // HUDを表示して指定時間後に非表示にする
                    HUD.flash(.error, delay: 2)
                } else {
                    print("ユーザ情報登録成功！！")
                    let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc : UIViewController = storyboard.instantiateViewController(withIdentifier: "test") as! UITabBarController
                    let nv = UINavigationController(rootViewController: vc)
                    HUD.hide()
                    self.present(nv, animated: true, completion: nil)
                }
            }
        }
        
        // ユーザ画像登録処理
        func uploadImage(uid: String) {
            // ストレージサービスへの参照を取得
            let storage = Storage.storage()
            //保存するURLを指定
            let storageRef = storage.reference(forURL: "gs://debuet-7732b.appspot.com/")
            //ディレクトリを指定
            let imageRef = storageRef.child("User").child(uid)
            guard let data = userInfomation.userPicture else { return }
            //保存を実行して、metadataにURLが含まれているので、あとはよしなに加工
            let imageData = data.jpegData(compressionQuality: 0.1)! as NSData
            imageRef.putData(imageData as Data, metadata: nil) { metadata, error in
                if (error != nil) {
                    // HUDを表示して指定時間後に非表示にする
                    HUD.hide()
                    HUD.flash(.error, delay: 2)
                    self.resultLabel.text = self.errormessage.showErrorIfNeeded(error)
                    print("画像登録失敗！！")
                } else {
                    print("画像登録成功！！")
                }
            }
        }
        
        // viewを押下時にキーボードを閉じる処理
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
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
