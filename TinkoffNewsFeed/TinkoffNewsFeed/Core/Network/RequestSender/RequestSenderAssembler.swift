//
// Created by Evgeniy on 26.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation

final class RequestSenderAssembler: IRequestSenderAssembler {
    class func assembly() -> IRequestSender {
        let sender = RequestSender()

        return sender
    }
}
