TikTokenSwift is a Swift implementation of OpenAI's Tiktoken tokenizer.

Currently it supports the following tokenizers:
o200k_base
cl100k_base
p50k_edit
p50k_base
r50k_base
gpt2

It has unicode support and is able to handle UTF-8 encoded character literals ie "\u0001".

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
- Gpt2 encoding is broken due to its encoder.json not matching up to values given by educational code. The tests expect " world" to be 995 but in the encoder that is some unicode value with world 
