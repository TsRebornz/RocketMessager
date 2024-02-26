//
//  ViewController.swift
//  RocketMessager
//
//  Created by Anton Makarenkov on 15.02.24.
//

import Combine
import UIKit

final class ViewController: UIViewController {

    // MARK: - Private
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Send message", for: .normal)
        button.tintColor = .red
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    var socketManager: RMSocketManager?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        socketManager = RMSocketManager()
        socketManager?.connect("TM")
    }
    
    // MARK: - Private
    
    private func setupLayout() {
        view.backgroundColor = .red
        view.addSubview(button)
        NSLayoutConstraint.activate(
            [
                button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ]
        )
    }
    
    @objc private func buttonTapped() {
        socketManager?.sendMessage("testing")
    }

}

