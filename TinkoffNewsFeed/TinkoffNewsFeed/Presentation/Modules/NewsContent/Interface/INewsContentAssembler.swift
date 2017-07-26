//
//  INewsContentAssembler.swift
//  TinkoffNewsFeed
//
//  Created by Evgeniy on 26.07.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import Foundation

protocol INewsContentAssembler {
    static func assembly() -> NewsContentDependencies
}

