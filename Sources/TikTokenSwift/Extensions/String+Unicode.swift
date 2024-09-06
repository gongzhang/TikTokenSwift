//
//  String+Unicode.swift
//
//
//  Created by Richard Perry on 9/5/24.
//

import Foundation

extension String {
    func convertFromUnicodeString() -> String? {
        // Swift uses ICU values. Convert from Hex by using special key Hex-Any
        // Info yoinked from https://unicode-org.github.io/icu/userguide/transforms/general/#basic-ids
        let hexTransform = StringTransform("Hex-Any")
        return self.applyingTransform(hexTransform, reverse: false)
    }
}
