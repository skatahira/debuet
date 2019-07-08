//
//  ErrorMessage.swift
//  debuet
//
//  Created by 片平駿介 on 2019/07/05.
//  Copyright © 2019 ShunsukeKatahira. All rights reserved.
//

import UIKit
import Firebase

// エラーメッセージ関連クラス
class ErrorMessage: UIViewController {
    func showErrorIfNeeded(_ errorOrNil: Error?) -> String {
        
        // エラーがなければ何も処理を行わない
        guard let error = errorOrNil else { return "" }
        
        // エラーメッセージを取得
        let message = errorMessage(of: error)
        
        return message
        
//        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        present(alert, animated: true, completion: nil)
        
    }
    
    private func errorMessage(of error: Error) -> String {
        var message = "エラーが発生しました"
        guard let errcd = AuthErrorCode(rawValue: (error as NSError).code) else {
            return message
        }
        
        switch errcd {
        case .networkError:
            message = "ネットワークに接続できません"
        case .userNotFound:
            message = "ユーザが見つかりません"
        case .invalidEmail:
            message = "不正なメールアドレスです"
        case .emailAlreadyInUse:
            message = "このメールアドレスは既に使われています"
        case .wrongPassword:
            message = "パスワードが間違っています"
        case .userDisabled:
            message = "このアカウントは無効です"
        case .weakPassword:
            message = "パスワードが脆弱すぎます"
        default:
            break
        }
        return message
    }
}
