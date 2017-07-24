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
            log.info("error while initializing connectionChecker!")
        }

        try? connectionChecker?.startNotifier()
        connectionChecker?.whenReachable = onActiveConnection
        connectionChecker?.whenUnreachable = onLostConnection
    }

    private func onActiveConnection(_ info: Reachability) {
        let m = "Internet is available!\nInfo: \(info)"

        log.info(m)
    }

    private func onLostConnection(_ info: Reachability) {

        // TODO: Use HUD to display connection error
        // show 

        let m = "Internet is unavailable!\nInfo: \(info)"

        log.info(m)
    }

    fileprivate let feedCellId = "idNewsFeedCell"

    fileprivate var itemsCount = 20

    fileprivate let itemsPerBatch = 20

    fileprivate var offset = 0

    fileprivate func loadMore() {
        // TODO: check if we've already reached end

        itemsCount += itemsPerBatch
        newsFeedTableView.reloadData()
    }
    
    fileprivate func onNewNewsLoaded() {
        
        // TODO: use core data to insert new rows
        
        newsFeedTableView.beginUpdates()
        
        
        
        newsFeedTableView.endUpdates()
    }
}


extension ViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsCount
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: feedCellId, for: indexPath) as! NewsFeedCell

        cell.newsTitleLabel.text = "news number: \(indexPath.row)"

        let row = indexPath.row
        if row == itemsCount - 2 {

            DispatchQueue.main.async { [unowned self] in
                self.loadMore()
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }

}


extension ViewController: UITableViewDelegate {

}
