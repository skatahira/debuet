//
//  ProfileCreateViewController.swift
//  debuet
//
//  Created by 片平駿介 on 2019/06/16.
//  Copyright © 2019 ShunsukeKatahira. All rights reserved.
//

import UIKit
import FlexibleSteppedProgressBar

class ProfileCreateViewController: UIViewController {
    
    @IBOutlet weak var stepIndicator: FlexibleSteppedProgressBar!
    
    
    // ContainerViewにEmbedしたUIPageViewontrollerのインスタンスを保持する
    fileprivate var pageViewController: UIPageViewController?
    
    // チュートリアル画面に表示する要素
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStepIndicator()
        
    }
    
    // ステップインジケータ表示の初期表示に関するセッティングをするメソッド
    private func setupStepIndicator() {
        stepIndicator.delegate = self
        
        // ステップインジケータの表示数を設定する
        stepIndicator.numberOfPoints = 3
        
        // ステップインジケータの線幅を設定する
        stepIndicator.lineHeight = 4
        
        // ステップインジケータの配色および外枠を設定する
        stepIndicator.selectedOuterCircleLineWidth = 4.0
        stepIndicator.selectedOuterCircleStrokeColor = UIColor.orange
        stepIndicator.currentSelectedCenterColor = UIColor.white
        
        // ステップインディケータのアニメーション秒数を設定する
        stepIndicator.stepAnimationDuration = 0.26
        
        // ステップインジケータの現在位置を設定する
        stepIndicator.currentIndex = 0
    }
    
}

// プログレスバー関連処理
extension ProfileCreateViewController: FlexibleSteppedProgressBarDelegate {
    
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
//        return true
        return false
    }
    
    func progressBar(_ progressBar: FlexibleSteppedProgressBar,
                     textAtIndex index: Int, position: FlexibleSteppedProgressBarTextLocation) -> String {
        return ""
    }
}
