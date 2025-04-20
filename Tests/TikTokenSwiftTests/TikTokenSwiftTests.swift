import XCTest
@testable import TikTokenSwift

final class TikTokenSwiftTests: XCTestCase {
    func testSimple() async throws {
        var enc = try? await TikTokenSwift.makeEncoding(model: .gpt2)
        XCTAssertNotNil(enc)
        var helloValue = try? enc!.encode(value: "hello world")
        XCTAssertNotNil(helloValue)
        XCTAssertEqual(helloValue!, [31373, 995])
        
        
        enc = try? await TikTokenSwift.makeEncoding(model: .gpt4)
        XCTAssertNotNil(enc)
        helloValue = try? enc!.encode(value: "hello world")
        XCTAssertNotNil(helloValue)
        XCTAssertEqual(helloValue!, [15339, 1917])
        let decodedHello = enc!.decode(value: helloValue!)
        XCTAssertEqual(decodedHello, "hello world")
    }
    
    func testSimpleRepeated() async throws {
        let enc = try? await TikTokenSwift.makeEncoding(model: .gpt2)
        XCTAssertNotNil(enc)
        var encodedString = try? enc!.encode(value: "0")
        XCTAssertNotNil(encodedString)
        XCTAssertEqual(encodedString!, [15])
        
        encodedString = try? enc!.encode(value: "00")
        XCTAssertNotNil(encodedString)
        XCTAssertEqual(encodedString!, [405])
        
        encodedString = try? enc!.encode(value: "000")
        XCTAssertNotNil(encodedString)
        XCTAssertEqual(encodedString!, [830])
        
        encodedString = try? enc!.encode(value: "0000")
        XCTAssertNotNil(encodedString)
        XCTAssertEqual(encodedString!, [2388])
        
        encodedString = try? enc!.encode(value: "00000")
        XCTAssertNotNil(encodedString)
        XCTAssertEqual(encodedString!, [20483])
        
        encodedString = try? enc!.encode(value: "000000")
        XCTAssertNotNil(encodedString)
        XCTAssertEqual(encodedString!, [10535])
        
        encodedString = try? enc!.encode(value: "0000000")
        XCTAssertNotNil(encodedString)
        XCTAssertEqual(encodedString!, [24598])
        
        encodedString = try? enc!.encode(value: "00000000")
        XCTAssertNotNil(encodedString)
        XCTAssertEqual(encodedString!, [8269])
        
        encodedString = try? enc!.encode(value: "000000000")
        XCTAssertNotNil(encodedString)
        XCTAssertEqual(encodedString!, [10535, 830])
        
        encodedString = try? enc!.encode(value: "0000000000")
        XCTAssertNotNil(encodedString)
        XCTAssertEqual(encodedString!, [8269, 405])

        encodedString = try? enc!.encode(value: "00000000000")
        XCTAssertNotNil(encodedString)
        XCTAssertEqual(encodedString!, [8269, 830])
        
        encodedString = try? enc!.encode(value: "000000000000")
        XCTAssertNotNil(encodedString)
        XCTAssertEqual(encodedString!, [8269, 2388])
        
        encodedString = try? enc!.encode(value: "0000000000000")
        XCTAssertNotNil(encodedString)
        XCTAssertEqual(encodedString!, [8269, 20483])
        
        encodedString = try? enc!.encode(value: "00000000000000")
        XCTAssertNotNil(encodedString)
        XCTAssertEqual(encodedString!, [8269, 10535])
        
        encodedString = try? enc!.encode(value: "000000000000000")
        XCTAssertNotNil(encodedString)
        XCTAssertEqual(encodedString!, [8269, 24598])
        
        encodedString = try? enc!.encode(value: "0000000000000000")
        XCTAssertNotNil(encodedString)
        XCTAssertEqual(encodedString!, [25645])
        
        encodedString = try? enc!.encode(value: "00000000000000000")
        XCTAssertNotNil(encodedString)
        XCTAssertEqual(encodedString!, [8269, 10535, 830])
    }
    
    func testCountTokens() async throws {
        // 测试不同模型的countTokens方法
        let testStrings = [
            "hello world",
            "This is a test string with multiple tokens.",
            "0123456789",
            "The quick brown fox jumps over the lazy dog",
            "",  // 空字符串测试
            "00000000000000000",  // 重复字符测试
            
            // 长文本测试
            String(repeating: "This is a longer text that will be repeated to test tokenization of lengthier content. ", count: 10),
            
            // 中文测试
            "你好，世界！这是一个用于测试中文分词的字符串。",
            "中国是世界上人口最多的国家，有着悠久的历史和灿烂的文化。",
            "春眠不觉晓，处处闻啼鸟。夜来风雨声，花落知多少。",
            
            // 日文测试
            "こんにちは世界！これは日本語のトークン化をテストするための文字列です。",
            "私は昨日東京に行きました。今日は大阪に行きます。",
            
            // 混合语言测试
            "This is English. 这是中文。これは日本語です。",
            
            // Emoji测试
            "I love coding! 😊👨‍💻🚀",
            "👨‍👩‍👧‍👦 Family emoji test with 🏠 and 🌳",
            "Emoji only: 🔥💯🙏🤔👍",
            
            // 特殊符号测试
            "Special characters: !@#$%^&*()_+-=[]{}|;':\",./<>?\\",
            "Math symbols: ∑∏∫√∂∇≠≈≤≥∞",
            
            // 混合内容测试
            "混合测试：英文、中文、日本語、123、!@#、😊🚀",
            
            // 非ASCII字符
            "Unicode symbols: ©®™℠℗№℃℉✓",
            
            // 超长句子
            "这是一个非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常长的句子，目的是测试分词系统对超长文本的处理能力。",
            
            // HTML和代码片段
            "<html><body><h1>Hello World</h1><p>This is HTML</p></body></html>",
            "function test() { console.log('Hello, World!'); return 42; }",
            
            // URL和路径
            "https://www.example.com/path/to/resource?query=value&another=123",
            "/Users/username/Documents/projects/myproject/src/main.swift",
            
            // 大写和小写混合
            "ThIs Is A MiXeD CaSe StRiNg FoR TeStInG",
            
            // 重复模式
            "abababababababababababababababababab",
            
            // 特殊Unicode块
            "𝔥𝔢𝔩𝔩𝔬 𝔴𝔬𝔯𝔩𝔡", // 古体字母
            "𝕙𝕖𝕝𝕝𝕠 𝕨𝕠𝕣𝕝𝕕", // 双线字母
            
            // 基于词的重复
            "Buffalo buffalo Buffalo buffalo buffalo buffalo Buffalo buffalo"
        ]
        
        // 测试不同的模型
        let models: [GptModel] = [.gpt2, .gpt4]
        
        for model in models {
            let enc = try await TikTokenSwift.makeEncoding(model: model)
            
            for testString in testStrings {
                // 通过encode方法获取token数量
                let tokens = try enc.encode(value: testString)
                let tokenCount = tokens.count
                
                // 通过countTokens方法获取token数量
                let countResult = enc.countTokens(plain: testString)
                
                // 验证两种方法的结果一致
                XCTAssertEqual(
                    tokenCount, 
                    countResult, 
                    "Token count mismatch for model \(model) with string '\(testString)': expected \(tokenCount), got \(countResult)"
                )
            }
        }
    }
    
}
