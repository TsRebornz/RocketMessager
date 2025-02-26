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
        case sendMessage(_ message: String)
        
        // Naming?
        var toString: String {
            switch self {
            case .connect:
                return EventName.connect.rawValue
            case .connectUser:
                return EventName.connectUser.rawValue
            case .sendMessage(_):
                return "message"
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
    private let logger: RMLogger
    
    private var uuid1: UUID?
    
    // MARK: - Init
    
    init(
        logger: RMLogger = RMLoggerBase()
    ) {
        socketManager = SocketManager(
            // FIXME: - Testing socket
            socketURL: URL(string: "http://192.168.2.64:3000")!,
            config: [.log(true), .compress, .forceWebsockets(true)]
        
        socket = socketManager.defaultSocket
        self.logger = logger
    }
    
    func connect(_ userName: String) {
        socket.connect()
        
        uuid1 = socket.on(clientEvent: .connect) { [weak self] data, ack in
            guard let self else { return }
            sendEvent(.connectUser(userName))
        }
    }
    
    func sendMessage(_ string: String) {
        sendEvent(.sendMessage(string))
    }
    
    // MARK: - Private
    
    private func sendEvent(_ event: Event) {
        switch event {
        case .connect:
            socket.connect()
        case .connectUser(let userName):
            socket.emit(event.toString, userName)
        case .sendMessage(let message):
            socket.emit(event.toString, message)
        }
    }
}
