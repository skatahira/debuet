//
//  UserInfomationEditViewController.swift
//  debuet
//
//  Created by 片平駿介 on 2019/07/09.
//  Copyright © 2019 ShunsukeKatahira. All rights reserved.
//

import UIKit
import Firebase

// ユーザ情報閲覧・編集画面
class UserInfomationEditViewController: UIViewController {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var birthDatePicker: UIDatePicker!
    @IBOutlet weak var manRadioButton: LTHRadioButton!
    @IBOutlet weak var womanRadioButton: LTHRadioButton!
    @IBOutlet weak var lowRadioButton: LTHRadioButton!
    @IBOutlet weak var moderateRadioButton: LTHRadioButton!
    @IBOutlet weak var highRadioButton: LTHRadioButton!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var userGoalTextView: UITextView!
    
    let errormessage = ErrorMessage.self()
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ログインしているユーザIDを取得
        guard let uid = Auth.auth().currentUser?.uid else {
            print("uid is nil")
            return
        }
        
        // ユーザ情報取得処理呼び出し
        getUserInfomation(uid: uid)
    }
}

// Firebase関連処理
extension UserInfomationEditViewController {
    
    // ユーザ情報取得処理
    func getUserInfomation(uid: String) {
        // ユーザ情報取得
        let docRef = db.collection("users").document(uid)
        docRef.getDocument { (document, error) in
            if error != nil {
                // エラー発生した場合
                print("Error")
                return
            } else {
                // プロフィールをセットする
                self.nickNameTextField.text = (document!.data()!["nickName"] as! String)
                self.heightTextField.text = (document!.data()!["height"] as! String)
                self.userGoalTextView.text = (document!.data()!["goalText"] as! String)
            }
        }
    }
}

// ユーザ画像関連処理
extension UserInfomationEditViewController {
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
