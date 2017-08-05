//
//  NewsListCacheManagerTests.swift
//  TinkoffNewsFeed
//
//  Created by Evgeniy on 05.08.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import XCTest
import CoreData
@testable import TinkoffNewsFeed

// Здесь какой-то баг в xcode:
// Если запустить тесты для всего класса сразу, то будет краш. По отдельности все работает правильно.

final class NewsListCacheManagerTests: XCTestCase {
    func testCache() {
        // given
        let news = NewsListPayload()
        news.id = newsId
        news.pubDate = newsPubDate
        news.title = newsTitle
        let titleHash = news.title.sha1()
        
        // when
        let manager = buildCacheManager()
        manager.cache([news])
        
        // then
        let cdWorker: ICoreDataWorker = CoreDataWorker(context: stack.saveContext)
        let cachedNews = cdWorker.getFirst(type: News.self)!
        
        XCTAssertEqual(cachedNews.id, newsId)
        XCTAssertEqual(cachedNews.pubDate! as Date, newsPubDate)
        XCTAssertEqual(cachedNews.title, newsTitle)
        XCTAssertEqual(cachedNews.titleHash, titleHash)
        XCTAssertEqual(cachedNews.viewsCount, exNewsViewsCount)
    }
    
    private func buildCacheManager() -> INewsListCacheManager {
        let cdWorker = CoreDataWorker(context: stack.saveContext)
        
        return NewsListCacheManager(contextManager: stack,
                                    saveContext: stack.saveContext,
                                    objectMapper: StructToEntityMapper.self,
                                    coreDataWorker: cdWorker)
    }
    
    func testUpdateCache() {
        // given
        testCache()
        let news = NewsListPayload()
        news.id = newsId
        news.pubDate = newsPubDate
        news.title = updatedTitle
        let titleHash = news.title.sha1()
        
        // when
        let manager = buildCacheManager()
        manager.cache([news])
        
        // then
        let cdWorker: ICoreDataWorker = CoreDataWorker(context: stack.saveContext)
        let cachedNews = cdWorker.getFirst(type: News.self)!
        
        XCTAssertEqual(cachedNews.id, newsId)
        XCTAssertEqual(cachedNews.pubDate! as Date, newsPubDate)
        XCTAssertEqual(cachedNews.title, updatedTitle)
        XCTAssertEqual(cachedNews.titleHash, titleHash)
        XCTAssertEqual(cachedNews.viewsCount, exNewsViewsCount)
    }
    
    private let newsId = "1"
    private let newsPubDate = Date(timeIntervalSince1970: 10_000)
    private let newsTitle = "News title"
    private let exNewsViewsCount: Int64 = 0
    private let updatedTitle = "Updated title"
    
    private let stack = CDStack(storeType: NSInMemoryStoreType)
}
