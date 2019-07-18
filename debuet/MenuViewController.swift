//
//  MenuViewController.swift
//  debuet
//
//  Created by 片平駿介 on 2019/07/16.
//  Copyright © 2019 ShunsukeKatahira. All rights reserved.
//

import UIKit
import GuillotineMenu
import Firebase

class MenuViewController: UIViewController, GuillotineMenu {
    
    var dismissButton: UIButton?
    var titleLabel: UILabel?
    
    let errormessage = ErrorMessage.self()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dismissButton = {
            let button = UIButton(frame: .zero)
            button.setImage(UIImage(named: "menur"), for: .normal)
            // なぜか何を押してもdismissButtonが呼ばれてしまうため非表示にする
            button.isHidden = true
            // button.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
            return button
        }()
        
        titleLabel = {
            let label = UILabel()
            label.numberOfLines = 1;
            label.text = ""
            label.font = UIFont.boldSystemFont(ofSize: 17)
            label.textColor = UIColor.white
            label.sizeToFit()
            return label
        }()
        
    }
    
    @objc func dismissButtonTapped(_ sender: UIButton) {
        presentingViewController!.dismiss(animated: true, completion: nil)
    }
    
    @objc func nonefunc(_ sender: UIButton) {
        print("yoyoyoyoyyo")
    }
    
    // プロフィールボタン押下
    @IBAction func didTapProfileBtn(_ sender: Any) {
        // プロフィール画面に遷移
        performSegue(withIdentifier: "toProfile", sender: nil)
    }
    
    // ログアウトボタン押下
    @IBAction func didTapLogoutBtn(_ sender: Any) {
        // アラートインスタンス作成
        let alert: UIAlertController = UIAlertController(title: "ログアウト",
                                                         message: "ログアウトしてもよろしいですか？",
                                                         preferredStyle:  UIAlertController.Style.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "ログアウト",
                                                         style: UIAlertAction.Style.default,
                                                         handler:{
                                                            // ログアウトボタンが押された時の処理
                                                            (action: UIAlertAction!) -> Void in
                                                            print("ログアウト")
                                                            do {
                                                                try Auth.auth().signOut()
                                                                self.performSegue(withIdentifier: "toTop", sender: nil)
                                                            } catch let error {
                                                                self.errormessage.showErrorIfNeeded(error)
                                                            }
        })
        // キャンセルボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            // キャンセルボタンが押された時の処理
            (action: UIAlertAction!) -> Void in
            print("Cancel")
        })
        
        // UIAlertControllerにActionを追加
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        // Alertを表示
        present(alert, animated: true, completion: nil)
    }
    
    // アカウント削除ボタン押下
    @IBAction func didTapAccountDeleteBtn(_ sender: Any) {
        
        // アラートインスタンス作成
        let alert: UIAlertController = UIAlertController(title: "アカウント削除",
                                                         message: "アカウント削除してもよろしいですか？",
                                                         preferredStyle:  UIAlertController.Style.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "アカウント削除",
                                                         style: UIAlertAction.Style.default,
                                                         handler:{
                                                            // ボタンが押された時の処理を書く
                                                            (action: UIAlertAction!) -> Void in
                                                            print("アカウント削除")
                                                            do {
                                                                let removeUser = Auth.auth().currentUser
                                                                removeUser?.delete(completion: nil)
                                                                self.performSegue(withIdentifier: "toTop", sender: nil)
                                                            } catch let error {
                                                                self.errormessage.showErrorIfNeeded(error)
                                                            }
        })
        // キャンセルボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("Cancel")
        })
        
        // ③ UIAlertControllerにActionを追加
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        // ④ Alertを表示
        present(alert, animated: true, completion: nil)
    }
    
    // 閉じるボタン押下
    @IBAction func closeMenu(_ sender: UIButton) {
        presentingViewController!.dismiss(animated: true, completion: nil)
    }
    
    
}

extension MenuViewController: GuillotineAnimationDelegate {
    
    func animatorDidFinishPresentation(_ animator: GuillotineTransitionAnimation) {
        print("menuDidFinishPresentation")
    }
    func animatorDidFinishDismissal(_ animator: GuillotineTransitionAnimation) {
        print("menuDidFinishDismissal")
    }
    
    func animatorWillStartPresentation(_ animator: GuillotineTransitionAnimation) {
        print("willStartPresentation")
    }
    
    func animatorWillStartDismissal(_ animator: GuillotineTransitionAnimation) {
        print("willStartDismissal")
    }
}

