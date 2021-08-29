//
//  AppDelegate.swift
//  MVVMSampleApp
//
//  Created by Arie Peretz on 17/08/2021.
//

import UIKit
import SwiftUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow()
        let viewController = UIHostingController(rootView: MainView())
        
        self.window?.rootViewController = viewController
        self.window?.makeKeyAndVisible()
        
        return true
    }
}

