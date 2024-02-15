//
//  RMSocketManager.swift
//  RocketMessager
//
//  Created by Anton Makarenkov on 15.02.24.
//

import Foundation
import SocketIO

protocol RMSocketManagerProtocol {
    func prepareSocket()
    func sendMessage(_ string: String)
}

final class RMSocketManager: RMSocketManagerProtocol {
    
    // MARK: - Public
    

    // MARK: - Private
    
    private let socketManager: SocketManager
    private var socket: SocketIOClient { socketManager.defaultSocket }
    
    // MARK: - Init
    
    init() {
        socketManager = SocketManager(
            // FIXME: - Testing socket
            socketURL: URL(string: "http://192.168.2.116:3001")!,
            config: [.log(true), .compress]
        )
    }
    
    func prepareSocket() {
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
        }
        socket.connect()
    }
    
    func sendMessage(_ string: String) {
        let _ = socket.emitWithAck("MessageEvent", with: [string])
    }
}
