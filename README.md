TikTokenSwift is a Swift implementation of OpenAI's Tiktoken tokenizer.

Currently it supports the following tokenizers:
- o200k_base
- cl100k_base
- p50k_edit
- p50k_base
- r50k_base
- gpt2

## Features
- Unicode support
- Support for UTF-8 encoded character literals ie "\u0001".
- Supports the disallowed_special option for encoding so special tokens are treated as normal strings.
- Supports non-english characters and emojis

## Usage

```swift
let tokenizerSwift = try? await TikTokenSwift.shared.getEncoding(.gpt4)
let tokens = try? tokenizerSwift?.encode(value: " \\u0850")
let tokenCount = tokens?.count

let reverted =  tokenizerSwift?.decode(value: tokens!)
```

## Known Issues:
- ~~Texts with encoded hex values ie " \x850" will not get encoded properly and will return the wrong values~~ Fixed
- Encoding with a special token in string ie "Hello <|endoftext|>" with allowed_special="all" isn't implemented
