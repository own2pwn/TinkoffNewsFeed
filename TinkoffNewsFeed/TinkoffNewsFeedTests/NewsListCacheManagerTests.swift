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

final class NewsListCacheManagerTests: XCTestCase {
    func testCache() {
        // given
        let news = NewsListPayload()
        news.id = newsId
        news.pubDate = newsPubDate
        news.title = newsTitle
        
        // when
        let manager = buildCacheManager()
        manager.cache([news])
        
        // then
        
    }
    
    private func buildCacheManager() -> INewsListCacheManager {
        let cdWorker = CoreDataWorker(context: stack.saveContext)
        
        return NewsListCacheManager(contextManager: stack,
                                    saveContext: stack.saveContext,
                                    objectMapper: StructToEntityMapper.self,
                                    coreDataWorker: cdWorker)
    }
    
    private let newsId = "1"
    private let newsPubDate = Date(timeIntervalSince1970: 10_000)
    private let newsTitle = "News title"
    
    private let stack = CDStack(storeType: NSInMemoryStoreType)
}
