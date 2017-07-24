//
//  ViewController.swift
//  TinkoffNewsFeed
//
//  Created by Evgeniy on 24.07.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import UIKit
import ReachabilitySwift

final class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        doThings()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    let connectionChecker = Reachability()

    private func doThings() {
        // TODO: check for internet connection
        try? connectionChecker?.startNotifier()
        connectionChecker?.whenReachable = onActiveConnection
        connectionChecker?.whenUnreachable = onLostConnection
    }
    
    private func onActiveConnection(_ info: Reachability) {
        let m = "Internet is available!\nInfo: \(info)"
        
        print(m)
    }
    
    private func onLostConnection(_ info: Reachability) {
        
        // TODO: Use HUD to display connection error
        
        let m = "Internet is unavailable!\nInfo: \(info)"
        
        print(m)
    }
}
