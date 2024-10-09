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
        
        var viewController = ChatViewController()
        navigationController.setViewControllers([viewController], animated: false)
        // FIXME: - Ref. Builder or dependency injection
        viewController = NavigationContollerConfigurator.configureChat(viewController: viewController) as! ChatViewController
        viewController.navigationItem.titleView = RMNavigationControllerTitleView()
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
                
        return true
    }
}

class NavigationContollerConfigurator {
    // FIXME: - Remove static
    static func configureChat(viewController: UIViewController) -> UIViewController {
        viewController.navigationItem.titleView = RMNavigationControllerTitleView()
        var imageView = UIImageView(image: #imageLiteral(resourceName: "AvatarTest"))
        var avatarBarItem = UIBarButtonItem(customView: imageView)
        
        viewController.navigationItem.rightBarButtonItems = [avatarBarItem]

        return viewController
    }
}

final class RMNavigationControllerTitleView: UIView {
    
    enum Config {
        enum Colors {
            static let titleTextColor = DesignColors.ChatTitle.tileTextColor
            static let subtitleTextColor = DesignColors.ChatTitle.subtitleTextColor
        }
    }
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textAlignment = .center
        label.textColor = Config.Colors.titleTextColor
        return label
    }()
    
    private var subtitleLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11.0)
        label.textAlignment = .center
        label.textColor = Config.Colors.subtitleTextColor
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
        configureData()
    }
    
    override required init?(coder: NSCoder) {
        fatalError("Not implemented ")
    }
    
    func configureData() {
        titleLabel.text = "John Abraham"
        subtitleLabel.text = "Active now"
    }
    
    func setupLayout() {
        let labelsStackView = UIStackView()
        labelsStackView.axis = .vertical
        labelsStackView.spacing = 0.0
        labelsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(labelsStackView)
        
        labelsStackView.addArrangedSubview(titleLabel)
        labelsStackView.addArrangedSubview(subtitleLabel)
        
        NSLayoutConstraint.activate(
            [
                labelsStackView.leadingAnchor.constraint(
                    equalTo: leadingAnchor,
                    constant: 12.0
                ),
                labelsStackView.topAnchor.constraint(
                    equalTo: topAnchor,
                    constant: 0.0
                ),
                labelsStackView.bottomAnchor.constraint(
                    equalTo: bottomAnchor,
                    constant: 0.0
                ),
                labelsStackView.trailingAnchor.constraint(
                    equalTo: trailingAnchor,
                    constant: -12.0
                )
            ]
        )
        
    }
}
