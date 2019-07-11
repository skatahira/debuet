//
//  FirstViewController.swift
//  debuet
//
//  Created by 片平駿介 on 2019/06/18.
//  Copyright © 2019 ShunsukeKatahira. All rights reserved.
//

import UIKit
import Firebase

// スプラッシュ画面
class FirstViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 50%まで縮小
        UIView.animate(
            withDuration: 0.5,
            delay: 0.5,
            options: UIView.AnimationOptions.curveEaseOut,
            animations: { () in
                self.imageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        },
            completion: { (Bool) in})
        
        // 8倍にする
        UIView.animate(
            withDuration: 0.6,
            delay: 1.0,
            options: UIView.AnimationOptions.curveEaseOut,
            animations: { () in
                self.imageView.transform = CGAffineTransform(scaleX: 8.0, y: 8.0)
                self.imageView.alpha = 0
        },
            completion: { (Bool) in
                //self.imageView.removeFromSuperview()
                // 画面遷移判断処理
                if Auth.auth().currentUser != nil {
                    // ログインしている場合
                    let user = Auth.auth().currentUser
                    
                    let userRef = Firestore.firestore().collection("users").document(user!.uid)
                    
                    userRef.getDocument { (document, error) in
                        // 画面遷移判断
                        if let document = document, document.exists {
                            // ユーザ情報登録完了している場合
                            self.performSegue(withIdentifier: "toHome", sender: nil)
                        } else {
                            // ユーザ情報登録をしていない場合
                            self.performSegue(withIdentifier: "toCreate", sender: nil)
                        }
                    }
                } else {
                    // ログインしていない場合
                    // TOP画面に遷移
                    self.performSegue(withIdentifier: "toTop", sender: nil)
                }
        })
        
    }
}
