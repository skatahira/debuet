//
//  HomeViewController.swift
//  debuet
//
//  Created by 片平駿介 on 2019/07/05.
//  Copyright © 2019 ShunsukeKatahira. All rights reserved.
//

import UIKit
import Cosmos
import Firebase
import GuillotineMenu
import PKHUD

// ホーム画面
class HomeViewController: UIViewController {
    
    @IBOutlet weak var barButton: UIButton!
    @IBOutlet weak var targetWeight: UILabel!
    @IBOutlet weak var needFoods: UILabel!
    @IBOutlet weak var todayWeightTextField: UITextField!
    @IBOutlet weak var todayBreakfast: CosmosView!
    @IBOutlet weak var todayLunch: CosmosView!
    @IBOutlet weak var todayDinner: CosmosView!
    @IBOutlet weak var lastWeight: UILabel!
    @IBOutlet weak var lastBreakfast: CosmosView!
    @IBOutlet weak var lastLunch: CosmosView!
    @IBOutlet weak var lastDinner: CosmosView!
    
    let db = Firestore.firestore()
    // エラーメッセージ
    let errormessage = ErrorMessage.self()
    // 日付関連クラス
    let dateRelation = DateRelation()
    // ユーザ情報計算処理クラス呼び出し
    let calculation = Calculation()
    // ドキュメントID
    var docuID = ""
    var calcWeight = 0
    var calcFoods = 0
    var calcHeight = 0
    
    fileprivate lazy var presentationAnimator = GuillotineTransitionAnimation()
    
    // 初期表示時
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Cosmos関連処理呼び出し
        setCosmos()
    }
    
    // 画面に表示される直前
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // ナビゲーションバー関連処理
        // 戻るボタン消す処理
        self.navigationItem.hidesBackButton = true
        let myBackButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = myBackButton
        self.parent?.navigationItem.title = "ホーム"
        let menuButton = UIBarButtonItem(image: UIImage(named: "menu"),
                                         style: UIBarButtonItem.Style.plain,
                                         target: self,
                                         action: #selector(HomeViewController.didTapMenuBtn))
        self.parent?.navigationItem.leftBarButtonItem = menuButton
        
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
    // 記録ボタン押下
    @IBAction func todayRecord(_ sender: Any) {
        HUD.show(.progress)
        // 本日の記録処理を呼び出す
        createTodayRecord()
        
        let breakfoods = todayBreakfast.rating
        let lunchfoods = todayLunch.rating
        let dinnerfoods = todayDinner.rating
        // 残り食事量を計算
        var resultFoods = calcFoods - Int(breakfoods) - Int(lunchfoods) - Int(dinnerfoods)
        if resultFoods < 0 {
            resultFoods = 0
        }
        needFoods.text = String(resultFoods)
        HUD.hide()
    }
    
    // viewを押下時にキーボードを閉じる処理
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

// Firebase関連処理
extension HomeViewController {
    
    // ユーザ情報登録処理
    func createTodayRecord() {
        let now = getNowDate()
        
        guard ((todayWeightTextField?.text) != nil) else { return }
        
        let todayWeight = todayWeightTextField.text
        let breakfastAmountFood = todayBreakfast.rating
        let lunchAmountFood = todayLunch.rating
        let dinnerAmountFood = todayDinner.rating
        var bMI:Float = 0.0
        
        if todayWeight != "" {
            // 本日の体重が記録されている場合
            bMI = calculation.calcBMI(weight: Float(todayWeight!)!, height: (Float(calcHeight) / 100))
            bMI = round(bMI)
        }
        
        // データベースに格納する情報
        let data: [String: Any] = [
            "day": now,
            "weight": todayWeight!,
            "BMI": bMI,
            "breakfast": breakfastAmountFood,
            "lunch": lunchAmountFood,
            "dinner": dinnerAmountFood
        ]
        
        
        guard let uid = Auth.auth().currentUser?.uid else {
            print("uid is nil")
            return
        }
        
        // アラート用変数定義
        var title = ""
        var message = ""
        let okText = "OK"
        
        let recordRef = db.collection("users").document(uid).collection("record")
        
        // 本日の記録をデータベースに登録
        if docuID == "" {
            // 本日の記録がされていなかった場合
            var ref: DocumentReference? = nil
            ref = recordRef.addDocument(data: data) { err in
                if err != nil {
                    // エラー発生した場合
                    title = "記録できませんでした"
                    message = self.errormessage.showErrorIfNeeded(err)
                    // アラート処理呼び出す
                    self.createAlert(title: title, message: message, okText: okText)
                } else {
                    // 登録できた場合
                    if self.todayWeightTextField.text != "" {
                        // ドキュメントIDの設定
                        self.docuID = ref!.documentID
                        if let todayWeight: Int = Int(self.todayWeightTextField.text!) {
                            let resultWeight = self.calcWeight - todayWeight
                            self.targetWeight.text = String(resultWeight)
                        }
                    }
                    title = "記録しました"
                    message = "記録してくれてありがとう！！"
                    // アラート処理呼び出す
                    self.createAlert(title: title, message: message, okText: okText)
                }
            }
        } else {
            // 本日の記録がすでにされていた場合、アップデート
            recordRef.document(docuID).setData(data) { err in
                if err != nil {
                    // エラー発生した場合
                    title = "記録できませんでした"
                    message = self.errormessage.showErrorIfNeeded(err)
                    // アラート処理呼び出す
                    self.createAlert(title: title, message: message, okText: okText)
                } else {
                    // 登録できた場合
                    if self.todayWeightTextField.text != "" {
                        if let todayWeight: Int = Int(self.todayWeightTextField.text!) {
                            let resultWeight = self.calcWeight - todayWeight
                            self.targetWeight.text = String(resultWeight)
                        }
                    } else if self.lastWeight.text != "" {
                        if let lastWeight2: Int = Int(self.lastWeight.text!) {
                            let resultWeight = self.calcWeight - lastWeight2
                            self.targetWeight.text = String(resultWeight)
                        }
                    } else if self.lastWeight.text == "" {
                        self.targetWeight.text = "-"
                    }
                    title = "記録しました"
                    message = "記録してくれてありがとう！！"
                    // アラート処理呼び出す
                    self.createAlert(title: title, message: message, okText: okText)
                }
            }
        }
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
                self.calcWeight = Int(document!.data()!["standardWeight"] as! Int)
                self.calcFoods = document!.data()!["oneDayAmountOfFood"] as! Int
                self.calcHeight = Int(document!.data()!["height"] as! String)!
            }
        }
    }
    
    // 本日の記録情報取得処理
    func getTodayRecord(uid: String) {
        let now = getNowDate()
        // 本日の記録取得
        let docRef = db.collection("users").document(uid).collection("record").whereField("day", isEqualTo: now)
        docRef.getDocuments { (docu, error) in
            if error != nil {
                // エラー発生した場合
                print("Error")
                return
            } else {
                for document in docu!.documents {
                    self.docuID = document.documentID
                    self.todayWeightTextField.text = (document.data()["weight"] as! String)
                    self.todayBreakfast.rating = Double(document.data()["breakfast"] as! Int)
                    self.todayLunch.rating = Double(document.data()["lunch"] as! Int)
                    self.todayDinner.rating = Double(document.data()["dinner"] as! Int)
                }
                let breakfoods = self.todayBreakfast.rating
                let lunchfoods = self.todayLunch.rating
                let dinnerfoods = self.todayDinner.rating
                // 残り食事量を計算
                var resultFoods = self.calcFoods - Int(breakfoods) - Int(lunchfoods) - Int(dinnerfoods)
                if resultFoods < 0 {
                    resultFoods = 0
                }
                self.needFoods.text = String(resultFoods)
            }
        }
    }
    
    // 前回の記録情報取得処理
    func getLastRecord(uid: String) {
        let now = getNowDate()
        // 前回の記録取得
        let docRef = db.collection("users").document(uid).collection("record").order(by: "day", descending: true).limit(to: 2)
        docRef.getDocuments { (docu, error) in
            if error != nil {
                // エラー発生した場合
                print("Error")
                return
            } else {
                for document in docu!.documents {
                    let getDay: Timestamp = document.data()["day"] as! Timestamp
                    let now2: Timestamp = Timestamp(date: now)
                    // 取得したデータが本日の場合は処理を飛ばす
                    if getDay != now2 {
                        self.lastWeight.text = (document.data()["weight"] as! String)
                        self.lastBreakfast.rating = Double(document.data()["breakfast"] as! Int)
                        self.lastLunch.rating = Double(document.data()["lunch"] as! Int)
                        self.lastDinner.rating = Double(document.data()["dinner"] as! Int)
                        break
                    }
                }
                // 目標体重までの増量数設定
                if self.todayWeightTextField.text != "" {
                    if let todayWeight: Int = Int(self.todayWeightTextField.text!) {
                        let resultWeight = self.calcWeight - todayWeight
                        self.targetWeight.text = String(resultWeight)
                    }
                } else if self.lastWeight.text != "" {
                    if let lastWeight2: Int = Int(self.lastWeight.text!) {
                        let resultWeight = self.calcWeight - lastWeight2
                        self.targetWeight.text = String(resultWeight)
                    }
                }
            }
        }
    }
}

// Cosmos関連処理
extension HomeViewController {
    // 初期表示時
    func setCosmos() {
        
        // ログインしているユーザIDを取得
        guard let uid = Auth.auth().currentUser?.uid else {
            print("uid is nil")
            return
        }
        
        // 本日の食事量を0に設定
        todayBreakfast.rating = 0
        todayLunch.rating = 0
        todayDinner.rating = 0
        // 前回の食事量を0に設定
        lastBreakfast.rating = 0
        lastLunch.rating = 0
        lastDinner.rating = 0
        
        // ユーザ情報取得
        getUserInfomation(uid: uid)
        
        // 本日の記録情報取得処理呼び出し
        getTodayRecord(uid: uid)
        // 前回の記録情報取得処理呼び出し
        getLastRecord(uid: uid)
        
        // 本日の朝食
        todayBreakfast.settings.minTouchRating = 0
        todayBreakfast.settings.filledImage = UIImage(named: "onigiri1.png")
        todayBreakfast.settings.emptyImage = UIImage(named: "onigiri2.png")
        // 本日の昼食
        todayLunch.settings.minTouchRating = 0
        todayLunch.settings.filledImage = UIImage(named: "onigiri1.png")
        todayLunch.settings.emptyImage = UIImage(named: "onigiri2.png")
        // 本日の夕飯
        todayDinner.settings.minTouchRating = 0
        todayDinner.settings.filledImage = UIImage(named: "onigiri1.png")
        todayDinner.settings.emptyImage = UIImage(named: "onigiri2.png")
        
        // 前回の朝食
        lastBreakfast.settings.updateOnTouch = false
        lastBreakfast.settings.filledImage = UIImage(named: "onigiri1.png")
        lastBreakfast.settings.emptyImage = UIImage(named: "onigiri2.png")
        // 前回の昼食
        lastLunch.settings.updateOnTouch = false
        lastLunch.settings.filledImage = UIImage(named: "onigiri1.png")
        lastLunch.settings.emptyImage = UIImage(named: "onigiri2.png")
        // 前回の夕飯
        lastDinner.settings.updateOnTouch = false
        lastDinner.settings.filledImage = UIImage(named: "onigiri1.png")
        lastDinner.settings.emptyImage = UIImage(named: "onigiri2.png")
    }
}

// アラート関連処理
extension HomeViewController {
    // アラート表示処理
    func createAlert(title: String, message: String, okText: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okayButton = UIAlertAction(title: okText, style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(okayButton)
        self.present(alert, animated: true, completion: nil)
    }
}

// 日付関連処理
extension HomeViewController {
    
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
extension HomeViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentationAnimator.mode = .presentation
        return presentationAnimator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentationAnimator.mode = .dismissal
        return presentationAnimator
    }
}
