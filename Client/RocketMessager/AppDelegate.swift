//
//  AppDelegate.swift
//  RocketMessager
//
//  Created by Anton Makarenkov on 15.02.24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let screenBounds = UIScreen.main.bounds
        window = UIWindow(frame: screenBounds)
        window?.rootViewController = ChatViewController()
        window?.makeKeyAndVisible()
                
        return true
    }
}
