//
// Created by Evgeniy on 24.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation

enum TNFCoreData {
    static let MODEL_NAME = "TNFDataModel"
    static let STORE_FULL_NAME = MODEL_NAME + ".sqlite"
}

extension String {
    static let TNF_CD_MODEL_NAME = TNFCoreData.MODEL_NAME
    static let TNF_CD_STORE_NAME = TNFCoreData.STORE_FULL_NAME
}