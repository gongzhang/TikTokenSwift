import Foundation

public enum TikTokenSwift {
    public static func makeEncoding(model: GptModel) async throws -> Encoding {
        let vocab = model.modelForEncoder
        let encoder = try await loadRanks(vocab)
        let regex = try NSRegularExpression(pattern: vocab.pattern)
        let encoding = try Encoding(name: model.rawValue, regex: regex, mergedRanks: encoder, specialTokens: vocab.specialTokens, explicitNVocab: vocab.explicitNVocab)
        return encoding
    }
    
    public static func makeEncoding(vocab: Vocab, at url: URL? = nil) async throws -> Encoding {
        let encoder = try await loadRanks(vocab, at: url)
        let regex = try NSRegularExpression(pattern: vocab.pattern)
        let encoding = try Encoding(name: vocab.name, regex: regex, mergedRanks: encoder, specialTokens: vocab.specialTokens, explicitNVocab: vocab.explicitNVocab)
        return encoding
    }
}

private extension TikTokenSwift {
    static func loadRanks(_ vocab: Vocab, at url: URL? = nil) async throws -> BpeRanks {
        if vocab.name == "gpt2" {
            return try await Load.dataGymToMergeableBpeRanks(vocab: vocab)
        } else {
            return try await Load.loadTiktokenBpe(vocab: vocab, at: url)
        }
    }
}
