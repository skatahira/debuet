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


class ProfileCreateViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, FlexibleSteppedProgressBarDelegate {
    
    @IBOutlet weak var stepIndicator: FlexibleSteppedProgressBar!
    @IBOutlet weak var userImageView: EnhancedCircleImageView!
    @IBOutlet weak var nickNameTextField: UITextField!
    
    // ContainerViewにEmbedしたUIPageViewontrollerのインスタンスを保持する
    fileprivate var pageViewController: UIPageViewController?
    
    let picker = UIImagePickerController()
    //let storage = StorageReference?.self
    // [1]ストレージ サービスへの参照を取得
    // let storage = FIRStorage.storage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        setupStepIndicator()
        
    }
    
    // 写真選択ボタン押下時
    @IBAction func didTapSelectImageBtn(_ sender: Any) {
        
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        present(picker, animated: true, completion: nil)
    }
    
    // 次へボタン押下時
    @IBAction func didClickNextBtn(_ sender: Any) {
        
        guard nickNameTextField.text != "" else{ return }
        
//         let storage = FIRS
    }
    
    // viewを押下時にキーボードを閉じる処理
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        //        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
        //            self.userImageView.image = image
        //        }
        self.dismiss(animated: true, completion: nil)
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


