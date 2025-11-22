//
//  NetworkMonitorService.swift
//  RecipeBook
//
//  Created by Леонид Шайхутдинов on 22.11.2025.
//

import Network
import UIKit

final class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    private let monitor: NWPathMonitor
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    private(set) var isConnected: Bool = false
    
    private init() {
        monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { [weak self] path in
            let status = path.status == .satisfied
            self?.isConnected = status
            
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .networkStatusChanged, object: status)
            }
        }

        monitor.start(queue: queue)
    }
}

extension Notification.Name {
    static let networkStatusChanged = Notification.Name("networkStatusChanged")
}
