//
//  ProfileCreateViewController.swift
//  debuet
//
//  Created by 片平駿介 on 2019/06/16.
//  Copyright © 2019 ShunsukeKatahira. All rights reserved.
//

import UIKit
import FlexibleSteppedProgressBar
import Firebase
import Validator

// ユーザ画像・ニックネーム登録画面
class ProfileCreateViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, FlexibleSteppedProgressBarDelegate {
    
    @IBOutlet weak var stepIndicator: FlexibleSteppedProgressBar!
    @IBOutlet weak var userImageView: EnhancedCircleImageView!
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var nickNameState: UILabel!
    @IBOutlet weak var nickNameCheckLabel: UILabel!
    
    // ContainerViewにEmbedしたUIPageViewontrollerのインスタンスを保持する
    fileprivate var pageViewController: UIPageViewController?
    
    let picker = UIImagePickerController()
    
    // ユーザインフォメーションインスタンス作成
    let userInfomation = UserInfomation()
    
    // バリデーションチェックルール
    let lengthRule = ValidationRuleLength(min: 1, max: 15, error: ValidationErrorType("💩"))
    
    // 画面遷移判断フラグ true=可 false=不可
    var transitionableFlg = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        self.parent?.navigationItem.title = "ユーザー情報入力"
        
        nickNameCheck()
        picker.delegate = self
        setupStepIndicator()
        
    }
    
    // 写真選択ボタン押下時
    @IBAction func didTapSelectImageBtn(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            present(imagePicker, animated: true, completion: nil)
        } else {
            print("フォトライブラリが使用できません")
        }
    }
    
    // 次へボタン押下時
    @IBAction func didClickNextBtn(_ sender: Any) {
        
        transitionableFlg = true
        // ニックネーム空文字チェック
        if nickNameTextField.text == "" {
            nickNameCheckLabel.text = "ニックネームを入力してください"
            transitionableFlg = false
        }
        
        guard nickNameTextField.text != "" else{ return }
        
        if nickNameState.text == "💩" {
            nickNameCheckLabel.text = "15文字以内で入力してください"
            transitionableFlg = false
        }
        
        if transitionableFlg {
            guard let userName = nickNameTextField.text else { return }
            userInfomation.setUserName(userName: userName)
            guard let userPicture = userImageView.image else { return }
            userInfomation.setUserPicture(userPicture: userPicture)
            
            self.performSegue(withIdentifier: "toNext", sender: userInfomation)
        }
    }
    
    // 次画面に渡す値を指定する
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toNext" {
            var userDetailEditViewController = segue.destination as! UserDetailEditViewController
            userDetailEditViewController.userInfomation = sender as! UserInfomation
        }
    }
    
    // viewを押下時にキーボードを閉じる処理
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // imagePickerController
    // 撮影または選択後に実行される処理
    // picker 表示しているカメラ画面あるいはライブラリ画面
    // info 撮影された画像または選択された画像
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // infoから画像を取り出す
        if let pickedImage = info[.originalImage] as? UIImage {
            // 画像の設定
            userImageView.image = pickedImage
            userImageView.contentMode = .scaleAspectFit
        }
        // 表示しているカメラ画面またはライブラリ画面を閉じる処理
        picker.dismiss(animated: true, completion: nil)
    }
    
}

// バリデーション関連処理
extension ProfileCreateViewController {
    // テキストが変更されたタイミングで実行される
    // ニックネーム入力チェック
    func nickNameCheck() {
        nickNameTextField.validationRules = ValidationRuleSet()
        nickNameTextField.validationRules?.add(rule: lengthRule)
        nickNameTextField.validateOnInputChange(enabled: true)
        nickNameTextField.validationHandler = {
            result in self.updateValidationNameState(result: result)
        }
    }
    
    // ニックネーム文字数チェック
    func updateValidationNameState(result: ValidationResult) {
        nickNameCheckLabel.text = ""
        switch result {
        case .valid:
            nickNameState.text = "😎"
        case .invalid(let failures):
            nickNameState.text = (failures.first as? ValidationErrorType)?.message
        }
    }
}

// プログレスバー関連処理
extension ProfileCreateViewController {
    
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
        stepIndicator.currentIndex = 0
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


