//
//  RMSocketManager.swift
//  RocketMessager
//
//  Created by Anton Makarenkov on 15.02.24.
//

import Foundation
import SocketIO

protocol RMSocketManagerProtocol {
    func connect(_ userName: String)
    func sendMessage(_ string: String)
}

final class RMSocketManager: RMSocketManagerProtocol {
    
    enum Event {
        case connect
        case connectUser(_ userName: String)
        
        // Naming?
        var toString: String {
            switch self {
            case .connect:
                return EventName.connect.rawValue
            case .connectUser:
                return EventName.connectUser.rawValue
            }
        }
    }
    
    private enum EventName: String {
        case connect
        case connectUser
    }
    
    // MARK: - Public
    

    // MARK: - Private
    
    private let socketManager: SocketManager
    private var socket: SocketIOClient
    
    // MARK: - Init
    
    init() {
        socketManager = SocketManager(
            // FIXME: - Testing socket
            socketURL: URL(string: "http://192.168.2.116:3000")!,
            config: [.log(true), .compress]
        )
        socket = socketManager.defaultSocket
    }
    
    func connect(_ userName: String) {
        socket.connect()
        
        socket.on(clientEvent: .connect) { [weak self] data, ack in
            guard let self else { return }
            sendEvent(.connectUser(userName))
        }
    }
    
    func sendMessage(_ string: String) {
        // do nothing
    }
    
    // MARK: - Private
    
    private func sendEvent(_ event: Event) {
        switch event {
        case .connect:
            socket.connect()
        case .connectUser(let userName):
            socket.emit(event.toString, userName)
        default:
            // do nothing
            break
        }
        
    }
}
