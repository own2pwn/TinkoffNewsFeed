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
import SwiftDate
import PKHUD

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
        // fetchedNewsCount = newsListFRC.sections![0].numberOfObjects
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
            newsFeedTableView.addPullToRefresh(refreshCompletion: onPull)
            if fetchedNewsCount > 0 {
                addPush2R(force: true)
            }
        }
    }

    private func addPush2R(force: Bool = false) {
        if force || newsFeedTableView.viewWithTag(PullToRefreshConst.pushTag) == nil {
            newsFeedTableView.addPushToRefresh(refreshCompletion: onLoadMore)
        }
    }

    private func removeP2R() {
        newsFeedTableView.removePullToRefreshView()
        newsFeedTableView.removePushToRefreshView()
    }

    private func onPull() {
        if isInternetAvailable {
            model.update(20) { error in
                if let e = error {
                    self.showError(title: "Can't update news!", subtitle: e)
                }
                DispatchQueue.main.async { [unowned self] in
                    self.newsFeedTableView.stopPullRefreshing()
                }
            }
        } else {
            showError(title: "Can't update news!", subtitle: "No internet connection!")
        }

        // TODO: disable after treshold to not block ui
        // and show warning that data hasn't been loaded
    }
    
    private var isInternetAvailable = false

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
        let title = displayModel.title.decodeHTML()
        let humanizedDate = humanDate(date)

        // TODO: various date formatting

        cell.newsDateLabel.text = humanizedDate
        cell.newsTitleLabel.text = title
        cell.newsViewsCountLabel.text = viewsCount.stringValue
    }

    private func humanDate(_ date: Date) -> String {

        var humanizedDate = ""

        if date.isToday {
            humanizedDate = date.time
        } else if date.isYesterday {
            humanizedDate = date.yesterdayFmt
        } else {
            humanizedDate = date.fullFmt
        }

        return humanizedDate
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
    private let hudFlashDelay = 1.0
    private let noConnectionTitle = "No internet connection"
    private let noConnectionSubtitle = "You still can see cached news"

    // MARK: - Instance members

    private let connectionChecker = Reachability(hostname: "api.tinkoff.ru")

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
            fillNewsIfEmpty()
        } else {
            showError(title: noConnectionTitle, subtitle: noConnectionSubtitle)
        }
    }

    private func showError(title: String?, subtitle: String?) {
        let hudContent: HUDContentType = .labeledError(title: title, subtitle: subtitle)
        HUD.flash(hudContent, delay: hudFlashDelay)
    }

    private func fillNewsIfEmpty() {
        if model.fetchedNewsCount == 0 {
            model.loadNews()
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
        isInternetAvailable = true
        DispatchQueue.main.async { [unowned self] in
            self.fillNewsIfEmpty()
            self.addPull2R()
        }
    }

    private func onLostConnection(_ info: Reachability) {
        isInternetAvailable = false
        DispatchQueue.main.async { [unowned self] in
            self.showError(title: self.noConnectionTitle, subtitle: self.noConnectionSubtitle)
            self.removeP2R()
        }
    }
}
