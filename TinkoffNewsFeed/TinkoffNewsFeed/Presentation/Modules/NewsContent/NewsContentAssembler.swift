//
//  NewsContentAssembler.swift
//  TinkoffNewsFeed
//
//  Created by Evgeniy on 26.07.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import Foundation

protocol INewsContentAssembler {
    static func assembly() -> NewsContentDependencies
}

struct NewsContentDependencies {
    let model: INewsContentModel
}

final class NewsContentAssembler: INewsContentAssembler {
    class func assembly() -> NewsContentDependencies {
        let d = NewsContentDependencies(model: newsContentModel)
        
        return d
    }
    
    // MARK: - Private
    
    private static var newsContentModel: INewsContentModel {
        return NewsContentModelAssembler.assembly()
    }
    
    private static var newsContentProvider: INewsContentProvider {
        return NewsContentProviderAssembler.assembly()
    }
    
    private static var objectMapper: IStructToEntityMapper.Type {
        return StructToEntityMapperAssembler.assembly()
    }
    
    private static var coreDataWorker: ICoreDataWorker {
        return CoreDataWorkerAssembler.assembly()
    }
    
    private static var contextManager: ICDContextManager {
        return CDStackAssembler.assembly()
    }
    
    private static var stackAssembler: ICDStack {
        return CDStackAssembler.assembly()
    }
    
    private static var requestSender: IRequestSender {
        return RequestSenderAssembler.assembly()
    }
}
