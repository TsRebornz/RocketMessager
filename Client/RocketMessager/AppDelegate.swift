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
        
        let navigationController = UINavigationController()
        // FIXME: - Ref. Builder or dependency injection
        let viewController = ChatViewController()
        viewController.navigationItem.titleView = RMNavigationControllerTitleView()
        navigationController.setViewControllers([viewController], animated: false)
        
        
        window?.rootViewController = navigationController
        
        window?.makeKeyAndVisible()
                
        return true
    }
}

final class RMNavigationControllerTitleView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    override required init?(coder: NSCoder) {
        fatalError("Not implemented ")
    }
    
    func setupLayout() {
        // TODO: Implement code of titleView here
    }
}


// FIXME: - Refactoring
final class RMNavigationController: UINavigationController {
    
}


