//
//  UserSettingViewController.swift
//  debuet
//
//  Created by 片平駿介 on 2019/07/20.
//  Copyright © 2019 ShunsukeKatahira. All rights reserved.
//

import UIKit

// 設定画面
class UserSettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // 各セクションのタイトル
    var array = ["アカウント", "プライバシー", "バージョン"]
    // アカウントに表示する内容
    let section1 = ["メールアドレスの再設定", "パスワードの再設定"]
    // 設定2に表示する内容
    let section2 = ["利用規約", "個人情報保護方針"]
    // バージョンに表示する内容
    let section3 = ["バージョン Ver1.00"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // ホームに戻るボタン押下
    @IBAction func didTapHomeBtn(_ sender: Any) {
        performSegue(withIdentifier: "toHome", sender: nil)
    }
    
    // セクションの数を設定
    func numberOfSections(in tableView: UITableView) -> Int {
        return array.count
    }
    
    // セクションに表示する内容
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return array[section] as? String
    }
    
    // セルの個数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return section1.count
        } else if section == 1 {
            return section2.count
        } else if section == 2 {
            return section3.count
        } else {
            return 0
        }

    }
    
    // セルに値を設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        // セルに表示する値を設定する
        if indexPath.section == 0 {
            cell.textLabel?.text = section1[indexPath.row]
        } else if indexPath.section == 1 {
            cell.textLabel?.text = section2[indexPath.row]
        } else if indexPath.section == 2 {
            cell.textLabel?.text = section3[indexPath.row]
        } else {
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        
        switch indexPath.section {
        case 0:
            // アカウントセクションの場合
            if indexPath.row == 0 {
                // メールアドレスの再設定押下
                performSegue(withIdentifier: "toChangeMail", sender: nil)
            } else if indexPath.row == 1 {
                // パスワードの再設定押下
                performSegue(withIdentifier: "toChangePass", sender: nil)
            }
            return indexPath
        case 1:
            // プライバシーセクションの場合
            return indexPath
            
        case 2:
            // バージョンセクションの場合
            // 洗濯不可
            return nil
        default:
            return indexPath
        }
    }
}

