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
    //defaultStore = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // プログレスバー関連処理呼び出し
        setupStepIndicator()
    }

    // 完了ボタン押下時
    @IBAction func didClickDoneBtn(_ sender: Any) {
        
        // ユーザネームを設定
        let user = Auth.auth().currentUser
        if let user = user {
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = "hogehoge"
            changeRequest.commitChanges { error in
                
                if let error = error {
                    print(error)
                    return
                }
                let when = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: when) {
                     self.performSegue(withIdentifier: "toHome", sender: nil)
                }
            }
            
        }
        
        var ref: DocumentReference? = nil
        
        
        guard goalTextView.text != "" else {
            return
        }
        
        let goalText: String = goalTextView.text
        
        
        ref = db.collection("users").addDocument(data: [
            "goalText" : goalText
        ]) { err in
            if err != nil {
                print("Error adding document")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
        
        performSegue(withIdentifier: "toHome", sender: nil)
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
