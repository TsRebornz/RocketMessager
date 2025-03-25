//
//  AppDelegate.swift
//  RocketMessager
//
//  Created by Anton Makarenkov on 15.02.24.
//

import UIKit

class tNameViewController: UIViewController {
    
    var transferToNextScreen: ((_ name: String) -> Void)?
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your name"
        return textField
    }()
    
    let button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next", for: .normal)
        button.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        setupUI()
    }
    
    @objc func handleNext() {
        guard let text = nameTextField.text, let transferToNextScreen else {
            fatalError("No name")
            return
        }
        transferToNextScreen(text)
    }
    
    func setupUI() {
        view.backgroundColor = .white
        let stackView = UIStackView(arrangedSubviews: [nameTextField, button])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        NSLayoutConstraint.activate(
            [
                stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ]
        )
    }
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let screenBounds = UIScreen.main.bounds
        window = UIWindow(frame: screenBounds)
        
        let navigationController = UINavigationController()
        
        //FIXME: - Extract to builder
        let socketManager: RMSocketManagerProtocol = RMSocketManager()
        var testMessageProvider: MessageListDataProvider = MessageListDataProviderImpl(
            socketManager: socketManager
        )
        // FIXME: - Extact to builder
        let chatViewModel = ChatViewModel(messageDataProvider: testMessageProvider)
        let mockNameViewController = tNameViewController()
        let chatListViewModel = ChatListViewModel(socketManager: socketManager)
        let chatListViewController = ChatListTableViewController(chatListViewModel: chatListViewModel)
        var viewController = ChatViewController(viewModel: chatViewModel)
        navigationController.setViewControllers([mockNameViewController], animated: false)
        // FIXME: - Ref. Builder or dependency injection
        let model = ChatNavigationControllerModel(
            title: "John Abraham",
            subtitle: "Active now",
            avatar: #imageLiteral(resourceName: "AvatarTest")
        )
        
        viewController = ChatNavigationContollerConfigurator.configureChat(viewController: viewController, model: model) as! ChatViewController
        
        mockNameViewController.transferToNextScreen = { name in
            navigationController.pushViewController(chatListViewController, animated: true)
        }
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
            static let titleTextColor = DesignColors.ChatTitle.titleTextColor
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
