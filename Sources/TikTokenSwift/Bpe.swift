//
//  Bpe.swift
//  
//
//  Created by Richard Perry on 9/2/24.
//

import Foundation

typealias Bpe = [[UInt8]: Int]

extension Bpe {
    var keyValueSwapped: [Int: [UInt8]] {
        reduce(into: [:], { $0[$1.value] = $1.key })
    }
}
