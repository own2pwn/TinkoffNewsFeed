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

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: feedCellId, for: indexPath) as! NewsFeedCell

        let row = indexPath.row
        cell.newsTitleLabel.text = "news number: \(row)"

        if row == itemsCount - 2 {
            DispatchQueue.main.async { [unowned self] in
                self.loadMore()
            }
        }
        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return NL_FOOTER_HEIGHT
    }

    // MARK: - Private

    // MARK: - Constants

    private let NL_FOOTER_HEIGHT: CGFloat = 10.0

    // MARK: - Instance members

    private let connectionChecker = Reachability()

    private let feedCellId = "idNewsFeedCell"

    private var itemsCount = 20

    private let itemsPerBatch = 20

    private var offset = 0

    // MARK: - Methods

    private func setupController() {
        initConnectionListener()
        setupView()
    }

    private func setupView() {
        // MARK: - UI
        let color = UIColor.init(red: 0.944989, green: 0.912527, blue: 0.518278, alpha: 0.751766)
        navigationController?.navigationBar.barTintColor = color

        // MARK: - TableView
        newsFeedTableView.estimatedRowHeight = 75
        newsFeedTableView.rowHeight = UITableViewAutomaticDimension

        // TODO: maybe use lib to p2r?
        // MARK: - Pull2Refresh
    }

    private func initConnectionListener() {
        if connectionChecker == nil {
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

    private func loadMore() {
        // TODO: check if we've already reached end

        if itemsCount == 40 {
            return
        }

        itemsCount += itemsPerBatch
        newsFeedTableView.reloadData()
    }

    private func onNewNewsLoaded() {
        // TODO: use core data to insert new rows

        newsFeedTableView.beginUpdates()
        newsFeedTableView.endUpdates()
    }
}
