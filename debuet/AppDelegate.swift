//
//  AppDelegate.swift
//  debuet
//
//  Created by 片平駿介 on 2019/06/10.
//  Copyright © 2019 ShunsukeKatahira. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared.enable = true
        FirebaseApp.configure()
        /*
        if let _ = Auth.auth().currentUser {
            // ログイン中
            let storyboard: UIStoryboard = UIStoryboard(name: "ProfileCreateViewController", bundle: nil)
            window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "ProfileCreateViewController")
        }
         */
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {

    }

    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {

    }

    func applicationDidBecomeActive(_ application: UIApplication) {

    }

    func applicationWillTerminate(_ application: UIApplication) {

    }


}

