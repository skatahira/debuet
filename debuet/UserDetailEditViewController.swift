//
//  UserDetailEditViewController.swift
//  debuet
//
//  Created by 片平駿介 on 2019/06/24.
//  Copyright © 2019 ShunsukeKatahira. All rights reserved.
//

import UIKit
import FlexibleSteppedProgressBar
import Validator

// ヘルスケア関連ユーザー情報登録画面
class UserDetailEditViewController: UIViewController,UITextFieldDelegate, FlexibleSteppedProgressBarDelegate {
    
    @IBOutlet weak var stepIndicator: FlexibleSteppedProgressBar!
    @IBOutlet weak var birthDatePicker: UIDatePicker!
    @IBOutlet weak var sexMaleRadioBtn: LTHRadioButton!
    @IBOutlet weak var sexFemaleRadioBtn: LTHRadioButton!
    @IBOutlet weak var physicalActiveLowBtn: LTHRadioButton!
    @IBOutlet weak var physicalActiveUsuallyBtn: LTHRadioButton!
    @IBOutlet weak var physicalActiveHighBtn: LTHRadioButton!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var heightState: UILabel!
    @IBOutlet weak var heightCheckLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    
    //今日の日付を代入
    let nowDate = NSDate()
    let dateFormat = DateFormatter()
    let inputDatePicker = UIDatePicker()
    
    // バリデーションチェックルール
    let lengthRule = ValidationRuleLength(min: 2, max: 3, error: ValidationErrorType("💩"))
    
    // 画面遷移判断フラグ true=可 false=不可
    var nextOkFlg = true
    
    // 前画面からユーザ情報を受け取る
    var userInfomation:UserInfomation = UserInfomation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // プログレスバー関連処理呼び出し
        setupStepIndicator()
        // ラジオボタン関連処理呼び出し
        sexRadio()
        physicalActiveLevelRadio()
        
        // 入力チェック処理呼び出し
        heightCheck()
        
        birthDatePicker.maximumDate = nowDate as Date
    }
    
    // 前へボタン処理
    @IBAction func didClickBackBtn(_ sender: Any) {
        performSegue(withIdentifier: "toBack", sender: nil)
    }
    
    // 次へボタン押下
    @IBAction func didClickNextBtn(_ sender: Any) {
        
        nextOkFlg = true
        
        clickBtnHeightCheck()
        
        if nextOkFlg {
            
            // 日付関連
            let dateFormatter = DateFormatter()
            dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale
            dateFormatter.dateFormat = "yyyyMMdd"
            let calcBirth:String = dateFormatter.string(from: birthDatePicker.date)
            let calcNow:String = dateFormatter.string(from: nowDate as Date)
            
            let birth = birthDatePicker.date
            var sex = ""
            var physicalActiveLevel = ""
            
            // 性別判断
            if sexMaleRadioBtn.isSelected {
                sex = "man"
            } else {
                sex = "woman"
            }
            // 身体活動レベル判断
            if physicalActiveLowBtn.isSelected {
                physicalActiveLevel = "low"
            } else if physicalActiveUsuallyBtn.isSelected {
                physicalActiveLevel = "usually"
            } else {
                physicalActiveLevel = "high"
            }
            let height: String = heightTextField!.text!
            // 各種計算処理実行
            calcUser(height: height, sex: sex, physicalActiveLevel: physicalActiveLevel, birth: calcBirth, calcNow: calcNow, userInfomation: userInfomation)
            
            userInfomation.setBirth(birth: birth)
            userInfomation.setSex(sex: sex)
            userInfomation.setPhysicalActiveLevel(physicalActiveLevel: physicalActiveLevel)
            userInfomation.setHeight(height: height)
            
            performSegue(withIdentifier: "toNext", sender: userInfomation)
            
        }
    }
    
    // 次画面に渡す値を指定する
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toNext" {
            var userGoalCreateViewController = segue.destination as! UserGoalCreateViewController
            userGoalCreateViewController.userInfomation = sender as! UserInfomation
        }
    }
    
    // viewを押下時にキーボードを閉じる処理
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

// ユーザ情報関連計算処理
extension UserDetailEditViewController {
    
    // ユーザ計算処理
    func calcUser(height: String, sex: String, physicalActiveLevel: String, birth: String,calcNow: String, userInfomation: UserInfomation) {
        // ユーザ情報計算処理クラス呼び出し
        let calculation = Calculation()
        let calcHeight: Float = Float(height) as! Float / 100
        // 標準体重取得
        let standardWeight = calculation.calcStandardWeight(height: calcHeight)
        // 年齢取得
        let age = calculation.calcAge(birth: birth,calcNow: calcNow)
        
        // 基礎代謝量
        var basalMetabolicRateman = 0
        if sex == "man" {
            basalMetabolicRateman = calculation.manCalcBasalMetabolicRate(weight: standardWeight, height: calcHeight, age: age)
        } else {
            basalMetabolicRateman = calculation.womanCalcBasalMetabolicRate(weight: standardWeight, height: calcHeight, age: age)
        }
        
        // 必要推定エネルギー量
        var requiredEnergy = 0
        if physicalActiveLevel == "low" {
            requiredEnergy = calculation.calcRequiredEnergy(basalMetabolicRate: basalMetabolicRateman, physicalActiveLevel: 1.5)
        } else if physicalActiveLevel == "usually" {
            requiredEnergy = calculation.calcRequiredEnergy(basalMetabolicRate: basalMetabolicRateman, physicalActiveLevel: 1.75)
        } else {
            requiredEnergy = calculation.calcRequiredEnergy(basalMetabolicRate: basalMetabolicRateman, physicalActiveLevel: 2.0)
        }
        
        // 必要食事量計算
        let amountOfFood = calculation.calcAmountOfFood(requiredEnergy: requiredEnergy)
        
        userInfomation.setAge(age: age)
        userInfomation.setStandardWeight(standardWeight: standardWeight)
        userInfomation.setBasalMetabolicRate(basalMetabolicRate: basalMetabolicRateman)
        userInfomation.setRequiredEnergy(requiredEnergy: requiredEnergy)
        userInfomation.setAmountOfFood(amountOfFood: amountOfFood)
        
    }
}

// バリデーション関連処理
extension UserDetailEditViewController {
    
    // 次へボタン押下時入力チェック
    func clickBtnHeightCheck() {
        // ニックネーム空文字チェック
        if heightTextField.text == "" {
            heightCheckLabel.text = "身長を入力してください"
            nextOkFlg = false
        }
        
        guard heightTextField.text != "" else {
            nextOkFlg = false
            return
        }
        
        if heightState.text == "💩" {
            heightCheckLabel.text = "正しい形式で入力してください"
            nextOkFlg = false
        }
    }
    // テキストが変更されたタイミングで実行される
    // 身長入力チェック
    func heightCheck() {
        heightTextField.validationRules = ValidationRuleSet()
        heightTextField.validationRules?.add(rule: lengthRule)
        heightTextField.validateOnInputChange(enabled: true)
        heightTextField.validationHandler = {
            result in self.updateValidationHeightState(result: result)
        }
    }
    
    // 身長文字数チェック
    func updateValidationHeightState(result: ValidationResult) {
        heightState.text = ""
        switch result {
        case .valid:
            heightState.text = "😎"
        case .invalid(let failures):
            heightState.text = (failures.first as? ValidationErrorType)?.message
        }
    }
}

// ラジオボタン関連処理
extension UserDetailEditViewController {
    // 性別ラジオボタン処理
    func sexRadio() {
        sexMaleRadioBtn.selectedColor = UIColor.hex(string: "#F9759D", alpha: 1)
        sexFemaleRadioBtn.selectedColor = UIColor.hex(string: "#F9759D", alpha: 1)
        // 初期値を男性にする
        sexMaleRadioBtn.select()
        
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
        // 初期値を低いにする
        physicalActiveLowBtn.select()
        
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
