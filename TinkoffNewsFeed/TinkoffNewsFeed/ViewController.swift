//
//  ViewController.swift
//  TinkoffNewsFeed
//
//  Created by Evgeniy on 24.07.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import UIKit
import ReachabilitySwift

final class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Outlets

    @IBOutlet weak var newsFeedTableView: UITableView!

    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        setupController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Private

    private let connectionChecker = Reachability()

    private func setupController() {
        initConnectionListener()
    }

    private func initConnectionListener() {
        if connectionChecker == nil {
            //TODO: add logger
            print("error while initializing connectionChecker!")
        }

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
        // show 

        let m = "Internet is unavailable!\nInfo: \(info)"

        print(m)
    }

    fileprivate let feedCellId = "idNewsFeedCell"
}


extension ViewController {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: feedCellId, for: indexPath) as! NewsFeedCell

        return cell
    }

}
