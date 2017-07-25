//
//  ViewController.swift
//  TinkoffNewsFeed
//
//  Created by Evgeniy on 24.07.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import UIKit
import ReachabilitySwift
import CoreData

// TODO: add loading indicator while fetching

final class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {

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

    deinit {
        connectionChecker?.stopNotifier()
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
        return footerHeight
    }

    // MARK: - NSFetchedResultsControllerDelegate

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        newsFeedTableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        newsFeedTableView.endUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any, at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            log.info("FRC insert obj: \(anObject)")
            if let indexPath = newIndexPath {

                newsFeedTableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case .delete:
            if let indexPath = indexPath {
                log.info("FRC delete obj: \(anObject)")
                log.info("New IP: \(indexPath)")
                newsFeedTableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case .update:
            if let indexPath = indexPath {
                log.info("FRC upd obj: \(anObject)")
                log.info("New IP: \(indexPath)")
                //let cell = newsFeedTableView.cellForRow(at: indexPath) as! NewsFeedCell
                //configureCell(cell, at: indexPath)
            }
            break
        case .move:
            log.info("FRC move obj: \(anObject)")
            log.info("Old IP: \(indexPath) | New IP: \(newIndexPath)")
            if let indexPath = indexPath {
                newsFeedTableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let newIndexPath = newIndexPath {
                newsFeedTableView.insertRows(at: [newIndexPath], with: .fade)
            }
            break
        }
    }

    private func display(_ object: Any) {
        // cell.selectionStyle = .none do i need this?


    }

    // MARK: - Private

    // MARK: - Constants

    private let footerHeight: CGFloat = 10.0

    // MARK: - Instance members

    private let connectionChecker = Reachability(hostname: "api.tinkoff.ru")
    // https:// ?

    private let feedCellId = "idNewsFeedCell"

    private var itemsCount = 20

    private let itemsPerBatch = 20

    private var offset = 0

    // MARK: - Methods

    private func setupController() {
        initConnectionListener()
        setupView()
        doThings()
    }

    var newsProvider: INewsListProvider!

    private func doThings() {
        // TODO: make one protocol for newlist and news content
        let stack = CDStack()
        let mapper = StructToEntityMapper.self
        let cm = NewsListCacheManager(contextManager: stack, objectMapper: mapper)
        let rs = RequestSender()

        newsProvider = NewsListProvider(cacheManager: cm, requestSender: rs)
        newsProvider.load(count: 15)
    }

    private func setupView() {

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
        let m = "Internet is available! | Info: \(info)"
        log.info(m)
    }

    private func onLostConnection(_ info: Reachability) {
        // TODO: Use HUD to display connection error
        // show

        let m = "Internet is unavailable! | Info: \(info)"
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
        // TODO: insert rows here
        newsFeedTableView.endUpdates()
    }
}
