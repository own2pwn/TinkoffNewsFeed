//
// Created by Evgeniy on 26.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation

/**

 If `error` is `true` then `content` is error message to be shown to user

 Else news content stored in `content`
 */
struct NewsContentDisplayModel {
    let error: Bool
    let content: String
}

final class NewsContentModel: INewsContentModel {

    // MARK: - Members

    weak var view: NewsContentViewDelegate!

    // MARK: - INewsContentModel

    func loadNewsContent(by id: String, completion: ((String?) -> Void)? = nil) {
        view.startLoadingAnimation()

        contentProvider.load(by: id) { [weak self] displayModel in
            let error = displayModel.error
            self?.view.stopLoadingAnimation()
            if error {
                completion?(displayModel.content)
            } else {
                completion?(nil)
                self?.view.present(displayModel)
            }
        }
    }

    // MARK: - DI

    init(contentProvider: INewsContentProvider) {
        self.contentProvider = contentProvider
    }

    private let contentProvider: INewsContentProvider
}
