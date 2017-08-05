//
//  NewsContentCacheManager.swift
//  TinkoffNewsFeed
//
//  Created by Evgeniy on 05.08.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import XCTest
import CoreData
@testable import TinkoffNewsFeed

// Здесь присутутствует баг из `NewsListCacheManagerTests`

final class NewsContentCacheManagerTests: XCTestCase {
    func testCache() {
        // given
        let news = News(context: stack.saveContext)
        news.id = newsId
        news.pubDate = newsPubDate
        news.title = newsTitle
        news.titleHash = news.title?.sha1()
        
        let newsContent = NewsContentPayload()
        newsContent.content = self.newsContent
        newsContent.createdAt = newsPubDate as Date
        newsContent.modifiedAt = newsPubDate as Date
        
        // when
        let manager = buildCacheManager()
        manager.cache(newsId, newsContent)
        
        // then
        let cdWorker: ICoreDataWorker = CoreDataWorker(context: stack.saveContext)
        let cachedNews = cdWorker.getFirst(type: NewsContent.self)!
        
        XCTAssertEqual(cachedNews.content, self.newsContent)
        XCTAssertEqual(cachedNews.createdAt, newsPubDate)
        XCTAssertEqual(cachedNews.modifiedAt, newsPubDate)
    }
    
    func testUpdateCache() {
        // given
        testCache()
        
        let newsContent = NewsContentPayload()
        newsContent.content = updatedContent
        newsContent.createdAt = newsPubDate as Date
        newsContent.modifiedAt = updatedModificationDate as Date
        
        // when
        let manager = buildCacheManager()
        manager.cache(newsId, newsContent)
        
        // then
        let cdWorker: ICoreDataWorker = CoreDataWorker(context: stack.saveContext)
        let cachedNews = cdWorker.getFirst(type: NewsContent.self)!
        
        XCTAssertEqual(cachedNews.content, updatedContent)
        XCTAssertEqual(cachedNews.createdAt, newsPubDate)
        XCTAssertEqual(cachedNews.modifiedAt, updatedModificationDate)
    }
    
    // MARK: - Private
    
    private func buildCacheManager() -> INewsContentCacheManager {
        let cdWorker = CoreDataWorker(context: stack.saveContext)
        
        return NewsContentCacheManager(contextManager: stack,
                                       saveContext: stack.saveContext,
                                       coreDataWorker: cdWorker,
                                       objectMapper: StructToEntityMapper.self)
    }
    
    private let newsId = "1"
    private let newsPubDate = NSDate(timeIntervalSince1970: 10_000)
    private let newsTitle = "News title"
    private let newsContent = "News content"
    
    private let updatedContent = "Updated content"
    private let updatedModificationDate = NSDate(timeIntervalSince1970: 15_000)
    
    private let stack = CDStack(storeType: NSInMemoryStoreType)
}
