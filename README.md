TikTokenSwift is a Swift implementation of OpenAI's Tiktoken tokenizer.

Currently it supports the following tokenizers:
o200k_base
cl100k_base
p50k_edit
p50k_base
r50k_base
gpt2

It has unicode support and is able to handle UTF-8 encoded character literals ie "\u0001".

Known Issues:
Texts with encoded hex values ie " \x850" will not get encoded properly and will return the wrong values
