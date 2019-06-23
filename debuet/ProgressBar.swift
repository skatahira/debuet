////
////  ProgressBar.swift
////  debuet
////
////  Created by 片平駿介 on 2019/06/20.
////  Copyright © 2019 ShunsukeKatahira. All rights reserved.
////
//
//import UIKit
//import FlexibleSteppedProgressBar
//
//
//// プログレスバー関連処理
//class ProgressBar: FlexibleSteppedProgressBarDelegate {
//
//    func progressBar(_ progressBar: FlexibleSteppedProgressBar,
//                     willSelectItemAtIndex index: Int) {
//        print("Index selected!")
//    }
//
//    // ステップインジケータの選択可否設定するメソッド
//    func progressBar(_ progressBar: FlexibleSteppedProgressBar,
//                     canSelectItemAtIndex index: Int) -> Bool {
//        return false
//    }
//
//    // ステップインジケータの各ステップの名称を設定
//    func progressBar(_ progressBar: FlexibleSteppedProgressBar,
//                     textAtIndex index: Int, position: FlexibleSteppedProgressBarTextLocation) -> String {
//        if position == FlexibleSteppedProgressBarTextLocation.bottom {
//            switch index {
//            case 0: return "Step1"
//            case 1: return "Step2"
//            case 2: return "Step3"
//            default: return ""
//            }
//        }
//        return ""
//    }
//}
