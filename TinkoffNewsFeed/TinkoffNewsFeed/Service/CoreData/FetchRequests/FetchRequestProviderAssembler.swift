//
// Created by Evgeniy on 26.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation

final class FetchRequestProviderAssembler: IFetchRequestProviderAssembler {
    class func assembly() -> IFetchRequestProvider.Type {
        let provider = FetchRequestProvider.self

        return provider
    }
}
