//
//  Load.swift
//  
//
//  Created by Richard Perry on 9/1/24.
//

import Foundation
import CryptoKit

struct Load {
    
    static func loadTiktokenBpe(vocab: Vocab, decoder: FileDecoder = FileDecoder()) async throws -> [[UInt8]: Int] {
        let vocabData = try await vocab.loadVocabData()
        var fileBpe = try decoder.decode(vocabData)
        addSpecialTokensToBpe(bpe: &fileBpe, specialTokens: vocab.specialTokens)
        return fileBpe
    }
    
    static func dataGymToMergeableBpeRanks(vocab: Vocab) async throws -> [[UInt8]: Int] {
        let encoderData = try await vocab.loadVocabData()
        var fileBpe = try createMergableBpeFromDataGym(vocabData: encoderData)
        // Add the special string to the rank
        addSpecialTokensToBpe(bpe: &fileBpe, specialTokens: vocab.specialTokens)
        let encoderValidationData = try await vocab.loadVocabValidationData()
        let isValidated = validateBpeGymData(encoderJsonData: encoderValidationData, mergedBpe: fileBpe)
        if !isValidated {
            throw TikTokenError.validation
        }
        return fileBpe
    }
    
    static func addSpecialTokensToBpe(bpe: inout [[UInt8]: Int], specialTokens: [String: Int]) {
        for key in specialTokens.keys {
            let utf8EncodedKey: [UInt8] = Array(key.utf8)
            bpe[utf8EncodedKey] = specialTokens[key]
        }
    }
    
    static func createMergableBpeFromDataGym(vocabData: Data) throws -> [[UInt8]: Int] {
        let maxVal = Int(pow(2.0, 8))
        let rangeToMaxValue = 0...UInt8(maxVal-1)
        var theChars: [[UInt8]] = []
        var filtered = rangeToMaxValue.filter { currentCharacterValue in
            let unicodeValue = Unicode.Scalar(currentCharacterValue)
            let scaleVale = unicodeValue.properties.generalCategory
            // Logic obtained by adding values Python's isPrintable returned to a set and then adding the categories that weren't in that set to see what they were
            return scaleVale  != .control && scaleVale != .format && scaleVale != .spaceSeparator
        }
        var byteToByte: [Character: Int] = [:]
        for val in filtered {
            let valInt = Int(val)
            guard let wantedChar = Character(unicodeValue:valInt) else {
                throw TikTokenError.unicode
            }
            byteToByte[wantedChar] = valInt
            theChars.append(Array(wantedChar.utf8))
        }

        var n = 0
        for num in rangeToMaxValue {
            let valInt = Int(num)
            if !filtered.contains(num) {
                filtered.append(num)
                guard let wantedCharacter = Character(unicodeValue: maxVal + n) else {
                    throw TikTokenError.unicode
                }
                byteToByte[wantedCharacter] = valInt
                theChars.append(Array(wantedCharacter.utf8))
                n += 1
            }
        }
        
        if filtered.count != maxVal {
            throw TikTokenError.bpeCountMismatch(256, filtered.count)
        }
        
        var oldStyleFile: [(first: [UInt8], second: [UInt8])] = []
        var first: [UInt8] = []
        var second: [UInt8] = []
        var parseFirst = true
        var currLine = 0
        for byte in vocabData {
            // Have we hit the space in the line?
            if (byte == 32) {
                parseFirst = false
            } else if (byte == 10) { // Have we hit a new line?
                // gpt2's first line is a version string so skip it
                if (currLine == 0) {
                    currLine += 1
                    first = []
                    second = []
                    parseFirst = true
                    continue
                }
                parseFirst = true
                oldStyleFile.append((first: first, second: second))
                currLine += 1
                first = []
                second = []
            } else {
                if parseFirst {
                    first.append(byte)
                } else {
                    second.append(byte)
                }
            }
        }
        var bpeRanks: [[UInt8]: Int] = [:]
        // Think there was a bug in the source OpenAI code since the validation json first 256 values did not match what their code returned.
        // Using the values gotten from adding the extra characters instead since they match the validation json
        for num in rangeToMaxValue {
            let valInt = Int(num)
            bpeRanks[theChars[valInt]] = valInt
        }
        n = bpeRanks.count
        for num in 0..<oldStyleFile.count {
            let currTuple = oldStyleFile[num]
            let mergedVal = currTuple.first + currTuple.second
            bpeRanks[mergedVal] = n
            n += 1
        }
        
        return bpeRanks
    }
    
    static func validateBpeGymData(encoderJsonData: Data, mergedBpe: [[UInt8]: Int]) -> Bool {
        // Going old school since it's easier to compare dict to dict
        let encodedJson: [String:Int]
        do {
            encodedJson = try JSONSerialization.jsonObject(with: encoderJsonData, options: .fragmentsAllowed) as? [String:Int] ?? [:]
        } catch {
            return false
        }
        if encodedJson.count == 0 {
            return false
        }
        
        for key in encodedJson.keys {
            let dictVal = encodedJson[key]
            
            let byteArr: [UInt8] = Array(key.convertFromUnicodeString()!.utf8)
            let byteVal = mergedBpe[byteArr]
            if dictVal != byteVal {
                return false
            }
        }
        return true
    }
}
