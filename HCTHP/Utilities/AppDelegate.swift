//
//  AppDelegate.swift
//  HCTHP
//
//  Created by Mahmudul Hasan on 2024-07-14.
//

import UIKit
import IQKeyboardManagerSwift

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // IQKM will handle user interaction with keyboard and help with views when keyboard appears
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.resignOnTouchOutside = true
        IQKeyboardManager.shared.toolbarConfiguration.previousNextDisplayMode = .alwaysHide

        return true
    }
}
