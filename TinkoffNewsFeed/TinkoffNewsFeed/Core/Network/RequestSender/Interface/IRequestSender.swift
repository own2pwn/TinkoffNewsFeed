//
// Created by supreme on 19/07/2017.
// Copyright (c) 2017 supreme. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol IRequestSender {
    func sendJSON<R>(config: RequestConfig<R, JSON>,
                     completionHandler: @escaping (IResult<R>) -> Void)
}

/// - R: - Result type
/// - F: - Response type to parse
struct RequestConfig<R, F> {
    let request: URLRequest
    let parser: IParser<R, F>
}
