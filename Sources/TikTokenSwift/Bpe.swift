//
//  Bpe.swift
//  
//
//  Created by Richard Perry on 9/2/24.
//

import Foundation

typealias BpeRanks = [[UInt8]: Int]

extension BpeRanks {
    var keyValueSwapped: [Int: [UInt8]] {
        reduce(into: [:], { $0[$1.value] = $1.key })
    }
}
