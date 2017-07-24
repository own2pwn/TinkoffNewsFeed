//
//  News+CoreDataProperties.swift
//  TinkoffNewsFeed
//
//  Created by Evgeniy on 24.07.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import Foundation
import CoreData


extension News {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<News> {
        return NSFetchRequest<News>(entityName: "News")
    }

    @NSManaged public var id: String?
    @NSManaged public var pubDate: NSDate?
    @NSManaged public var title: String?
    @NSManaged public var titleHash: NSObject?
    @NSManaged public var content: NewsContent?

}
