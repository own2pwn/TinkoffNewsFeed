//
//  NewsContent+CoreDataProperties.swift
//  TinkoffNewsFeed
//
//  Created by Evgeniy on 24.07.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import Foundation
import CoreData

extension NewsContent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NewsContent> {
        return NSFetchRequest<NewsContent>(entityName: "NewsContent")
    }

    @NSManaged public var content: String?
    @NSManaged public var createdAt: NSDate?
    @NSManaged public var modifiedAt: NSDate?
    @NSManaged public var news: News?

}
