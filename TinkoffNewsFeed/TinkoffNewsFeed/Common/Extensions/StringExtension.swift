//
// Created by Evgeniy on 25.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import UIKit

extension String {
    func decodeHTMLToAttributed() -> NSAttributedString? {
        let data = self.data(using: .utf8)
        let options: [String: Any] = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue]
        let string = try? NSAttributedString(data: data!, options: options, documentAttributes: nil)

        return string
    }

    func decodeHTML() -> String? {
        let decoded = self.decodeHTMLToAttributed()?.string

        return decoded
    }
}
