//
//  NewsListViewController.swift
//  TinkoffNewsFeed
//
//  Created by Evgeniy on 24.07.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import UIKit
import ReachabilitySwift
import CoreData
import PullToRefreshSwift

struct NewsListDisplayModel {
    let date: Date
    let viewsCount: Int
    let title: String
}

protocol NewsListViewDelegate: class {
    func startLoadingAnimation()
    func stopLoadingAnimation()

    func presentNewsDetails(_ model: NewsContentRoutingModel)
}

struct NewsContentRoutingModel {
    let id: String
    let title: String
    let content: String?
}

final class NewsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,
        NewsListViewDelegate, NSFetchedResultsControllerDelegate {

    // MARK: - Outlets

    @IBOutlet weak var newsFeedTableView: UITableView!

    @IBAction func didTapLoadButton(_ sender: UIButton) {
        model.loadNews()
    }

    func startLoadingAnimation() {
        setLoadingEnabled(true)
    }

    func stopLoadingAnimation() {
        setLoadingEnabled(false)
    }

    func presentNewsDetails(_ model: NewsContentRoutingModel) {
        performSegue(withIdentifier: showContentSegueId, sender: model)
    }

    private func setLoadingEnabled(_ state: Bool) {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = state
        }
    }

    private func updateFetchedNewsCount() {
        //fetchedNewsCount = newsListFRC.sections![0].numberOfObjects
        log.debug("New items count: \(fetchedNewsCount)")
    }

    private var fetchedNewsCount = 0

    // MARK: - Overrides
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        injectDependencies()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupController()
        setupView()
    }
    
    // MARK: - DI
    
    var model: INewsListModel!
    
    private let assembler: INewsListDependencyManager = DependencyManager()
    
    private func injectDependencies() {
        model = assembler.newsListModel(for: self)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let info = sender as? NewsContentRoutingModel,
           let dest = segue.destination as? NewsContentViewController {
            dest.assembler = assembler as! INewsContentDependencyManager
            dest.newsId = info.id
            dest.newsTitle = info.title
            if let content = info.content {
                dest.newsContent = content
            }
        }
    }

    private func addPull2R() {
        if newsFeedTableView.viewWithTag(PullToRefreshConst.pullTag) == nil {
            newsFeedTableView.addPullToRefresh(refreshCompletion: self.onPull)
            if fetchedNewsCount > 0 {
                addPush2R(force: true)
            }
        }
    }

    private func addPush2R(force: Bool = false) {
        if force || newsFeedTableView.viewWithTag(PullToRefreshConst.pushTag) == nil {
            newsFeedTableView.addPushToRefresh(refreshCompletion: self.onLoadMore)
        }
    }

    private func removeP2R() {
        newsFeedTableView.removePullToRefreshView()
        newsFeedTableView.removePushToRefreshView()
    }

    private func onPull() {

        // TODO: disable after treshold to not block ui
        // and show warning that data hasn't been loaded

        DispatchQueue.main.async {
            log.debug("pulled")
            sleep(1)
            log.debug("pulled [2]")

            self.newsFeedTableView.stopPullRefreshing()
        }
    }

    private func onLoadMore() {

        // TODO: disable after treshold to not block ui
        // and show warning that data hasn't been loaded

        DispatchQueue.main.async {
            log.debug("pushed")
            sleep(1)
            log.debug("pushed [2]")

            self.newsFeedTableView.stopPushRefreshing()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    deinit {
        connectionChecker?.stopNotifier()
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = model.rowsCount(for: section)

        return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: feedCellId, for: indexPath) as! NewsFeedCell
        configure(cell, at: indexPath)

        return cell
    }

    private func configure(_ cell: NewsFeedCell, at indexPath: IndexPath) {
        let displayModel = model.displayModel(for: indexPath)
        let date = displayModel.date
        let viewsCount = displayModel.viewsCount
        let title = displayModel.title
        let day = date.day

        //TODO: various date formatting

        cell.newsDateLabel.text = day
        cell.newsTitleLabel.text = title
        cell.newsViewsCountLabel.text = viewsCount.stringValue
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return footerHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        log.debug("on cell selection")
        model.presentNewsContent(for: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - NSFetchedResultsControllerDelegate

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        newsFeedTableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateFetchedNewsCount()
        addPush2R()
        newsFeedTableView.endUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any, at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            newsFeedTableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            newsFeedTableView.reloadRows(at: [indexPath!], with: .fade)
        case .insert:
            newsFeedTableView.insertRows(at: [newIndexPath!], with: .fade)
        case .move:
            newsFeedTableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }

    // MARK: - Private

    // MARK: - Constants

    private let footerHeight: CGFloat = 10.0
    private let feedCellId = "idNewsFeedCell"
    private let showContentSegueId = "idShowNewsContentSegue"

    // MARK: - Instance members

    private let connectionChecker = Reachability(hostname: "api.tinkoff.ru") //https?

    private var itemsCount = 20

    private let itemsPerBatch = 20

    private var offset = 0

    // MARK: - Methods

    private func setupController() {
        initConnectionListener()
    }

    private func setupView() {

        // MARK: - TableView
        newsFeedTableView.estimatedRowHeight = 75
        newsFeedTableView.rowHeight = UITableViewAutomaticDimension

        if connectionChecker!.isReachable {
            if model.fetchedNewsCount == 0 {
                // first time fetch
                model.loadNews()
            }
        } else {
            //show no internet
        }
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

        DispatchQueue.main.async { [unowned self] in
            self.addPull2R()
        }
    }

    private func onLostConnection(_ info: Reachability) {
        // TODO: Use HUD to display connection error
        // show

        let m = "Internet is unavailable! | Info: \(info)"
        log.info(m)
        DispatchQueue.main.async { [unowned self] in
            self.removeP2R()
        }
    }

    private func loadMore() {
        // TODO: check if we've already reached end

        DispatchQueue.global(qos: .userInitiated).async { [unowned self] in
            log.debug("Load more fetched count: \(self.fetchedNewsCount)")
        }

        if fetchedNewsCount >= 40 {
            return
        }
    }
}
