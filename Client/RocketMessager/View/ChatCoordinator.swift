//
//  ChatCoordinator.swift
//  RocketMessager
//
//  Created by Anton Makarenkov on 05.05.25.
//

import UIKit

protocol Coordinator {
    func coordinateToChatList()
}

final class ChatCoordinator: Coordinator {
    
    private weak var navigationController: UINavigationController!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func coordinateToChatList() {
        
    }
}
