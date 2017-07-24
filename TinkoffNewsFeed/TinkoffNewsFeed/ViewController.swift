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
        setupView()
    }
    
    private func setupView() {
        let color = UIColor.init(red: 0.944989, green: 0.912527, blue: 0.518278, alpha: 0.751766)
        
        newsFeedTableView.estimatedRowHeight = 75
        newsFeedTableView.rowHeight = UITableViewAutomaticDimension
        navigationController?.navigationBar.barTintColor = color
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
        
        if itemsCount == 40 {return}

        itemsCount += itemsPerBatch
        newsFeedTableView.reloadData()
    }
    
    fileprivate func onNewNewsLoaded() {
        
        // TODO: use core data to insert new rows
        
        newsFeedTableView.beginUpdates()
        
        
        
        newsFeedTableView.endUpdates()
    }
}

// MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsCount
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: feedCellId, for: indexPath) as! NewsFeedCell

        let row = indexPath.row
        cell.newsTitleLabel.text = "news number: \(row)"
        
        if row > 22 {
            cell.newsTitleLabel.text = "long news news news news"
        }
        
        if row == 15 || row == 25 {
            cell.newsTitleLabel.text = "long news news\n news news"
        }
        
        if row == 23 {
            cell.newsTitleLabel.text = "К ипотечной платформе Тинькофф Банка подключились два новых партнера: ЮниКредит Банк и СМП Банк"
        }

        if row == itemsCount - 2 {

            DispatchQueue.main.async { [unowned self] in
                self.loadMore()
            }
        }
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }
}
