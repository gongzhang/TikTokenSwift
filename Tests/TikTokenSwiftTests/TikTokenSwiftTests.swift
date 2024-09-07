import XCTest
@testable import TikTokenSwift

final class TikTokenSwiftTests: XCTestCase {
    func testExample() throws {
        // XCTest Documentation
        // https://developer.apple.com/documentation/xctest

        // Defining Test Cases and Test Methods
        // https://developer.apple.com/documentation/xctest/defining_test_cases_and_test_methods
        
    }
    
    func testSimple() async throws {
        let enc = try? await TikTokenSwift.shared.getEncoding(.gpt4)
        XCTAssertNotNil(enc)
        let helloValue = try? enc!.encode(value: "hello world")
        XCTAssertNotNil(helloValue)
        XCTAssertEqual(helloValue!, [15339, 1917])
        let decodedHello = enc!.decode(value: helloValue!)
        XCTAssertEqual(decodedHello, "hello world")
    }
    
    func testSimpleRepeated() async throws {

        let enc = try? await TikTokenSwift.shared.getEncoding(.gpt2)
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
}
