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
        //FIXME: - Extract to builder
        let socketManager: RMSocketManagerProtocol = RMSocketManager()
        let testMessageProvider: MessageListDataProvider = MessageListDataProviderImpl(socketManager: socketManager)
        let chatViewModel = ChatViewModel(messageDataProvider: testMessageProvider)
        var viewController = ChatViewController(viewModel: chatViewModel)
        navigationController.setViewControllers([viewController], animated: false)
        // FIXME: - Ref. Builder or dependency injection
        let model = ChatNavigationControllerModel(
            title: "John Abraham",
            subtitle: "Active now",
            avatar: #imageLiteral(resourceName: "AvatarTest")
        )
        viewController = ChatNavigationContollerConfigurator.configureChat(viewController: viewController, model: model) as! ChatViewController
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
                
        return true
    }
}

struct ChatNavigationControllerModel {
    let title: String
    let subtitle: String
    let avatar: UIImage
}

class ChatNavigationContollerConfigurator {
    // FIXME: - Remove static
    static func configureChat(
        viewController: UIViewController,
        model: ChatNavigationControllerModel
    ) -> UIViewController {
        var titleView = RMNavigationControllerTitleView(model: model)
        viewController.navigationItem.titleView = titleView
        let imageView = UIImageView(image: model.avatar)
        let avatarBarItem = UIBarButtonItem(customView: imageView)
        
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
    
    private var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11.0)
        label.textAlignment = .center
        label.textColor = Config.Colors.subtitleTextColor
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    convenience init(model: ChatNavigationControllerModel) {
        self.init(frame: .zero)
        configureData(model: model)
    }
        
    override required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    func configureData(model: ChatNavigationControllerModel) {
        titleLabel.text = model.title
        subtitleLabel.text = model.subtitle
        setNeedsLayout()
        layoutIfNeeded()
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
