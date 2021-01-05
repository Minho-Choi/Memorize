//
//  Array+Only.swift
//  Memorize
//
//  Created by Minho Choi on 2021/01/05.
//

import Foundation

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
