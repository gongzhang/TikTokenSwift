//
//  Encoding.swift
//  
//
//  Created by Richard Perry on 9/1/24.
//

import Foundation

public class Encoding {
    
    private let name: String
    private let regex: NSRegularExpression // Regex
    private let mergedRanks: [[UInt8]: Int]
    private let specialTokens: [String: Int]
    private let explicitNVocab: Int?
    
    private let coreBpe: CoreBPE
    
    init(name: String, regex: NSRegularExpression, mergedRanks: [[UInt8]: Int], specialTokens: [String: Int], explicitNVocab: Int? = nil) throws {
        self.name = name
        self.regex = regex
        self.mergedRanks = mergedRanks
        self.specialTokens = specialTokens
  
        // Make sure the bpe list count matches vocab value
        self.explicitNVocab = explicitNVocab
        if let explicitVocabCount = explicitNVocab {
            let totalVocab = mergedRanks.keys.count
            if totalVocab != explicitVocabCount {
                throw TikTokenError.bpeCountMismatch(explicitVocabCount, totalVocab)
            }
        }
        
        let decoder = mergedRanks.keyValueSwapped
        self.coreBpe = .init(encoder: mergedRanks, decoder: decoder, regexTls: [regex])
    }
    
    public func encode(value: String, allowedSpecialTokens: Set<String> = []) throws -> [Int] {
        if (allowedSpecialTokens.contains("all") == false) {
            for specialToken in specialTokens.keys {
                if (value.contains(specialToken) && allowedSpecialTokens.contains(specialToken) == false) {
                    throw TikTokenError.disallowedToken(specialToken)
                }
            }
        }
        
        return try coreBpe.encodeOrdinaryNative(text: value.convertFromUnicodeString() ?? value)
    }
    
    public func decode(value: [Int]) -> String {
        coreBpe.decodeNative(tokens: value)
    }
}
