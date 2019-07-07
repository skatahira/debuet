//
//  UserDetailEditViewController.swift
//  debuet
//
//  Created by 片平駿介 on 2019/06/24.
//  Copyright © 2019 ShunsukeKatahira. All rights reserved.
//

import UIKit
import FlexibleSteppedProgressBar

// ログイン前ヘルスケア関連ユーザー情報登録画面
class UserDetailEditViewController: UIViewController,UITextFieldDelegate, FlexibleSteppedProgressBarDelegate {
    
    @IBOutlet weak var stepIndicator: FlexibleSteppedProgressBar!
    @IBOutlet weak var birthDatePicker: UIDatePicker!
    @IBOutlet weak var sexMaleRadioBtn: LTHRadioButton!
    @IBOutlet weak var sexFemaleRadioBtn: LTHRadioButton!
    @IBOutlet weak var physicalActiveLowBtn: LTHRadioButton!
    @IBOutlet weak var physicalActiveUsuallyBtn: LTHRadioButton!
    @IBOutlet weak var physicalActiveHighBtn: LTHRadioButton!
    
    //変数を宣言する
    //今日の日付を代入
    let nowDate = NSDate()
    let dateFormat = DateFormatter()
    let inputDatePicker = UIDatePicker()
    
    // 前画面からユーザ情報を受け取る
    var userInfomation:UserInfomation = UserInfomation()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("\(userInfomation.userName)")
        
        // プログレスバー関連処理呼び出し
        setupStepIndicator()
        // ラジオボタン関連処理呼び出し
        sexRadio()
        physicalActiveLevelRadio()
        
        birthDatePicker.maximumDate = nowDate as Date
    }
    
    // 前へボタン処理
    @IBAction func didClickBackBtn(_ sender: Any) {
        performSegue(withIdentifier: "toBack", sender: nil)
    }
    
    // 次へボタン押下
    @IBAction func didClickNextBtn(_ sender: Any) {
        
        let birth = birthDatePicker.date
        userInfomation.setBirth(birth: birth)
        performSegue(withIdentifier: "toNext", sender: userInfomation)
    }
    
    // 次画面に渡す値を指定する
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toNext" {
            var userGoalCreateViewController = segue.destination as! UserGoalCreateViewController
            userGoalCreateViewController.userInfomation = sender as! UserInfomation
        }
    }
}


// 日付関連処理
extension UserDetailEditViewController {
    
    
}

// ラジオボタン関連処理
extension UserDetailEditViewController {
    // 性別ラジオボタン処理
    func sexRadio() {
        sexMaleRadioBtn.selectedColor = UIColor.hex(string: "#F9759D", alpha: 1)
        sexFemaleRadioBtn.selectedColor = UIColor.hex(string: "#F9759D", alpha: 1)
        
        // 男性を選択
        sexMaleRadioBtn.onSelect {
            self.sexFemaleRadioBtn.deselect()
        }
        // 女性を選択
        sexFemaleRadioBtn.onSelect {
            self.sexMaleRadioBtn.deselect()
        }
    }
    
    // 身体活動レベルラジオボタン処理
    func physicalActiveLevelRadio() {
        physicalActiveLowBtn.selectedColor = UIColor.hex(string: "#F9759D", alpha: 1)
        physicalActiveUsuallyBtn.selectedColor = UIColor.hex(string: "#F9759D", alpha: 1)
        physicalActiveHighBtn.selectedColor = UIColor.hex(string: "#F9759D", alpha: 1)
        
        // 低いを選択
        physicalActiveLowBtn.onSelect {
            self.physicalActiveUsuallyBtn.deselect()
            self.physicalActiveHighBtn.deselect()
        }
        // 普通を選択
        physicalActiveUsuallyBtn.onSelect {
            self.physicalActiveLowBtn.deselect()
            self.physicalActiveHighBtn.deselect()
        }
        // 高いを選択
        physicalActiveHighBtn.onSelect {
            self.physicalActiveLowBtn.deselect()
            self.physicalActiveUsuallyBtn.deselect()
        }
    }
}

// プログレスバー関連処理
extension UserDetailEditViewController {
    
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
        stepIndicator.currentIndex = 1
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
