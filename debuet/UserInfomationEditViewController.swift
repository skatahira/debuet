//
//  UserInfomationEditViewController.swift
//  debuet
//
//  Created by 片平駿介 on 2019/07/09.
//  Copyright © 2019 ShunsukeKatahira. All rights reserved.
//

import UIKit
import Firebase
import PKHUD

// ユーザ情報閲覧・編集画面
class UserInfomationEditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
    let picker = UIImagePickerController()

    // ユーザ情報受け取り変数の定義
    var receiveSex = ""
    var receivePhysicalActiveLevel = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ログインしているユーザIDを取得
        guard let uid = Auth.auth().currentUser?.uid else {
            print("uid is nil")
            return
        }
        // ラジオボタン関連処理呼び出し
        sexRadio()
        physicalActiveLevelRadio()
        // ユーザ情報取得処理呼び出し
        getUserInfomation(uid: uid)
        // ユーザ画像取得処理呼び出し
//        loadImage(uid: uid)
    }
    
    // 選択ボタン押下
    @IBAction func didTapImageChangeBtn(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            present(imagePicker, animated: true, completion: nil)
        } else {
            print("フォトライブラリが使用できません")
        }
    }
    
    // 保存ボタン押下
    @IBAction func didClickSaveBtn(_ sender: Any) {
        
    }
    
    // ホームに戻るボタン押下
    @IBAction func didClickHomeBtn(_ sender: Any) {
        performSegue(withIdentifier: "toHome", sender: nil)
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
                let receiveBirth: Timestamp = (document!.data()!["birth"] as! Timestamp)
//                let date = String(receiveBirth)
//                self.birthDatePicker.date = NSDate(receiveBirth: Timestamp)
                self.receiveSex = (document!.data()!["sex"] as! String)
                self.receivePhysicalActiveLevel = (document!.data()!["physicalActiveLevel"] as! String)
                // 表示用のデータに変換し、画面にセットする処理呼び出し
                self.userDisplayConversion()
            }
        }
    }
    
    // ユーザ画像取得処理
    func loadImage(uid: String) {
        //StorageのURLを参照
        let userImageURL: String = "gs://debuet-7732b.appspot.com/"
        let storageRef = Storage.storage().reference(forURL: userImageURL).child("User").child(uid)
        storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
            // Create a UIImage, add it to the array
            let pic = UIImage(data: data!)
            //画像をセット
            self.userImageView.image = pic
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
        guard let data = userImageView.image else { return }
        //保存を実行して、metadataにURLが含まれているので、あとはよしなに加工
        let imageData = data.jpegData(compressionQuality: 0.1)! as NSData
        imageRef.putData(imageData as Data, metadata: nil) { metadata, error in
            if (error != nil) {
                // HUDを表示して指定時間後に非表示にする
                HUD.flash(.error, delay: 2)
                self.errormessage.showErrorIfNeeded(error)
                print("画像登録失敗！！")
            } else {
                print("画像登録成功！！")
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

// ユーザ情報表示関連処理
extension UserInfomationEditViewController {
    
    // 初期表示用データ変換処理
    func userDisplayConversion() {
        
        // 性別をセット
        if receiveSex == "man" {
            manRadioButton.select()
        } else if receiveSex == "woman" {
            womanRadioButton.select()
        }
        
        // 身体活動レベルをセット
        if receivePhysicalActiveLevel == "low" {
            lowRadioButton.select()
        } else if receivePhysicalActiveLevel == "usually" {
            moderateRadioButton.select()
        } else if receivePhysicalActiveLevel == "high" {
            highRadioButton.select()
        }
        
    }
}

// ラジオボタン関連処理
extension UserInfomationEditViewController {
    // 性別ラジオボタン処理
    func sexRadio() {
        manRadioButton.selectedColor = UIColor.hex(string: "#F9759D", alpha: 1)
        womanRadioButton.selectedColor = UIColor.hex(string: "#F9759D", alpha: 1)
        
        // 男性を選択
        manRadioButton.onSelect {
            self.womanRadioButton.deselect()
        }
        // 女性を選択
        womanRadioButton.onSelect {
            self.manRadioButton.deselect()
        }
    }
    
    // 身体活動レベルラジオボタン処理
    func physicalActiveLevelRadio() {
        lowRadioButton.selectedColor = UIColor.hex(string: "#F9759D", alpha: 1)
        moderateRadioButton.selectedColor = UIColor.hex(string: "#F9759D", alpha: 1)
        highRadioButton.selectedColor = UIColor.hex(string: "#F9759D", alpha: 1)
        
        // 低いを選択
        lowRadioButton.onSelect {
            self.moderateRadioButton.deselect()
            self.highRadioButton.deselect()
        }
        // 普通を選択
        moderateRadioButton.onSelect {
            self.lowRadioButton.deselect()
            self.highRadioButton.deselect()
        }
        // 高いを選択
        highRadioButton.onSelect {
            self.lowRadioButton.deselect()
            self.moderateRadioButton.deselect()
        }
    }
}
