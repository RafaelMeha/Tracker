//
//  Strings.swift
//  CryptoTracker
//
//  Created by Oriakhi Collins on 6/27/22.
//

import Foundation

extension String {
    var removeHtmlOccurrence: String{
        return self.replacingOccurrences(of:  "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
