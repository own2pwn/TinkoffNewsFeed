//
// Created by supreme on 19/07/2017.
// Copyright (c) 2017 supreme. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

final class RequestSender: IRequestSender {

    func sendJSON<R>(config: RequestConfig<R, JSON>,
                     completionHandler: @escaping (IResult<R>) -> Void) {

        let urlRequest = config.request
        let error = IResult<R>.error

        request(urlRequest).responseJSON { response in
            if let e = response.error?.localizedDescription {
                let e = "Got error for req: \(urlRequest)\nError: " + e
                log.error(e)
                
                completionHandler(error(e))
                return
            }
            guard let response = response.result.value else {
                let e = "Received data is nil!\nRequest was: \(urlRequest)"
                log.error(e)
                
                completionHandler(error(e))
                return
            }

            let json = JSON(response)
            if let parsed = config.parser.parse(json) {
                let success = IResult.success(parsed)
                
                completionHandler(success)
            } else {
                let e = "Received data can't be parsed!\nData: \(json)"
                log.error(e)
                
                completionHandler(error(e))
            }
        }
    }
}
