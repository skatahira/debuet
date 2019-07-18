//
//  MyPageWeightViewController.swift
//  debuet
//
//  Created by 片平駿介 on 2019/07/14.
//  Copyright © 2019 ShunsukeKatahira. All rights reserved.
//

import UIKit
import Charts
import Firebase
import FirebaseFirestore
import GuillotineMenu

// マイページ(体重)画面
class MyPageWeightViewController: UIViewController {
    
    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var standardWeight: UILabel!
    @IBOutlet weak var nowBMI: UILabel!
    @IBOutlet weak var nowWeight: UILabel!
    
    // 表示に使うデータ
    //var data:[Double] = [3,1,6,8]
    var data:[Double] = []
    let db = Firestore.firestore()
    
    // 日付関連クラス
    let dateRelation = DateRelation()
    fileprivate lazy var presentationAnimator = GuillotineTransitionAnimation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        self.parent?.navigationItem.title = "マイページ"
        getUserInfomation(uid: getUserID())
        getNowRecord(uid: getUserID())
        
        navigationController?.navigationBar.backgroundColor = .red
        let menuButton = UIBarButtonItem(image: UIImage(named: "menu"),
                                         style: UIBarButtonItem.Style.plain,
                                         target: self,
                                         action: #selector(MyPageWeightViewController.didTapMenuBtn))
        self.parent?.navigationItem.leftBarButtonItem = menuButton
        
        // 現在年日時を取得
        let now = getNowDate()
        // グラフ開始年月日取得
        let before = Calendar.current.date(byAdding: .day, value: -6, to: now)!
        // 体重記録を取得
        getWeight(uid: getUserID(), fromDay: before, toDay: now)
        
        // グラフを追加する
        //        addGraph()
    }
    
    // メニューボタン押下時
    @objc func didTapMenuBtn() {
        let menuViewController = storyboard!.instantiateViewController(withIdentifier: "MenuViewController")
        menuViewController.modalPresentationStyle = .custom
        menuViewController.transitioningDelegate = (self as UIViewControllerTransitioningDelegate)
        
        presentationAnimator.animationDelegate = menuViewController as? GuillotineAnimationDelegate
        presentationAnimator.supportView = navigationController!.navigationBar
        //presentationAnimator.presentButton = sender
        presentationAnimator.presentButton = view
        present(menuViewController, animated: true, completion: nil)
    }
    
    
}

// Firebase関連処理
extension MyPageWeightViewController {
    
    // ユーザID取得処理
    func getUserID() -> String {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("uid is nil")
            return ""
        }
        return uid
    }
    
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
                self.standardWeight.text = String((document!.data()!["standardWeight"] as! Int))
            }
        }
    }
    
    // 現在の記録取得処理
    func getNowRecord(uid: String) {
        // 現在の記録取得
        let docRef = db.collection("users").document(uid).collection("record").order(by: "day", descending: true).limit(to: 1)
        docRef.getDocuments { (docu, error) in
            if error != nil {
                // エラー発生した場合
                print("Error")
                return
            } else {
                for document in docu!.documents {
                    self.nowWeight.text = (document.data()["weight"] as! String)
                    self.nowBMI.text = String(document.data()["BMI"] as! Float)
                }
            }
        }
    }
    
    // 体重記録取得処理
    func getWeight(uid: String, fromDay: Date, toDay: Date) {
        // 体重情報をリフレッシュする
        data = []
        // 体重記録取得
        let docRef = db.collection("users").document(uid).collection("record")
            .whereField("day", isGreaterThan: fromDay)
            .whereField("day", isLessThan: toDay)
            .order(by: "day")
        docRef.getDocuments { (docu, error) in
            if error != nil {
                // エラー発生した場合
                print("Error")
                return
            } else {
                for document in docu!.documents {
                    self.data.append(Double(document.data()["weight"] as! String) as! Double)
                }
                // グラフを追加する
                self.addGraph()
            }
        }
    }
}


// グラフ関連処理
extension MyPageWeightViewController {
    
    // グラフを画面に追加する
    func addGraph() {
        // 位置とサイズ
        let width: CGFloat = view.bounds.width
        let height: CGFloat = view.bounds.height / 4 * 3
        let rect = CGRect(x:0, y: 30, width: width, height: height)
        
        // グラフ表示部のインスタンス化
        //        chartView = LineChartView(frame: rect)
        // 表示データの設定
        chartView?.data = getDataSet()
        // 画面に追加
        view.addSubview(chartView!)
    }
    
    // 表示用のデータの整形
    func getDataSet() -> LineChartData {
        
        // データにある情報をグラフ用のデータに変換
        print(data)
        let entries = data.enumerated().map { ChartDataEntry(x: Double($0.offset), y: $0.element) }
        // 折れ線グラフのデータセット
        let dataSet = LineChartDataSet(entries: entries, label: "体重")
        return LineChartData(dataSet: dataSet)
    }
}

// 日付関連処理
extension MyPageWeightViewController {
    
    // Date型から強制的に「年月日」以外のデータを切り捨て、現在の年月日を取得する処理
    func getNowDate() -> Date {
        // 現在日付を取得(例えば 2017/07/12 12:01)
        let todayDate = Date()
        // カレンダーを取得
        let  calendar = Calendar(identifier: .gregorian)
        
        // today_dateから年月日のみ抽出する -> 2017/07/12となる
        let todayDateRounded =  dateRelation.roundDate(todayDate, calendar: calendar)
        
        return todayDateRounded
    }
}

// メニュー関連処理
extension MyPageWeightViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentationAnimator.mode = .presentation
        return presentationAnimator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentationAnimator.mode = .dismissal
        return presentationAnimator
    }
}
