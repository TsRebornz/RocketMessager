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
        case sendMessage(_ userName: String, _ message: String)
        
        // Naming?
        var toString: String {
            switch self {
            case .connect:
                return ClientEventName.connect.rawValue
            case .connectUser:
                return ClientEventName.connectUser.rawValue
            case .sendMessage(_, _):
                return "message"
            }
        }
    }
    
    private enum ClientEventName: String {
        case connect
        case connectUser
    }
    
    private enum ServerEventName: String {
        case userConnectUpdate
        case users
    }
    
    // MARK: - Public
    

    // MARK: - Private
    
    private let socketManager: SocketManager
    private var socket: SocketIOClient
    private let logger: RMLogger
    
    private var userId: String?
    // FIXME: Remove force unwrapp
    private var userData: UserData!
    
    // MARK: - Init
    
    init(
        logger: RMLogger = RMLoggerBase()
    ) {
        socketManager = SocketManager(
            // FIXME: - Testing socket
            socketURL: URL(string: "http://192.168.2.83:3000")!,
            config: [.log(true), .compress, .forceWebsockets(true)]
        )
        socket = socketManager.defaultSocket
        self.logger = logger
    }
    
    // FIXME: Refactoring
    private let jsonDecoder = JSONDecoder()
    
    struct UserData {
        let nickName: String
    }
    
    struct UserConnectUpdate: Decodable {
        /*
         Structure
            {
                id = "/#EBBk03Ca3zxqSJOjAAAB";
                isConnected = 1;
                nickname = Test;
            }
        */
        let id: String
        let isConnected: Bool
        let nickname: String
        
        enum CodingKeys: String, CodingKey {
            case id
            case isConnected
            case nickname
        }
        
        
        init(from decoder: any Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try values.decode(String.self, forKey: .id)
            self.isConnected = (
                try? values.decode(Int.self, forKey: .isConnected) > 0
                ? true
                : false
            ) ?? false
            self.nickname = try values.decode(String.self, forKey: .nickname)
        }
    }
    
    func connect(_ userName: String) {
        socket.connect()
        userData = .init(nickName: userName)
        
        socket.on(clientEvent: .connect) { [unowned self] data, ack in
            self.sendEvent(.connectUser(userName))
        }
        
        socket.on(ServerEventName.userConnectUpdate.rawValue) { [unowned self, jsonDecoder] invalidDataArray, emitter in
            guard let data = invalidDataArray[0] as? NSDictionary else {
                return
            }
                                
            self.userId = data["id"] as? String
        }
        
        socket.on(ServerEventName.users.rawValue) { dataArray, _ in
            print("ServerEventName.users called")
            guard let data = dataArray[0] as? NSDictionary else {
                fatalError("puk")
                return
            }
            print("ServerEventName.users called data \(data)")
        }
        
        socket.on("message") { dataArray, emitter in
            guard let data = dataArray[0] as? NSDictionary else {
                return
            }
            print("message is \(data)")
        }
    }
    
        func sendMessage(_ string: String) {        
        sendEvent(.sendMessage(userData.nickName, string))
    }
    
    // MARK: - Private
    
    private func disconnect() {
        socket.disconnect()
    }
    
    private func sendEvent(_ event: Event) {
        switch event {
        case .connect:
            socket.connect()
        case .connectUser(let userName):
            socket.emit(event.toString, userName)
        case .sendMessage(let userName, let message):
            socket.emit(event.toString, userName, message)
        }
    }
}
