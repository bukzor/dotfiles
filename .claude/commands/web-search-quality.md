---
description: How to write effective WebSearch queries
disable-model-invocation: true
---

(or: how to use WebSearch effectively)

Bad: `Web Search("site:github.com "CLI LLM code assistant" OR "terminal AI coding" OR "command line GPT" OR "CLI Claude"")`

Why: Quotes on phrases requires the exact phrase to appear, so it inadvertently excludes all slightly-different phrasings of the same content.

Bad: `Web Search("site:github.com CLI LLM code assistant terminal AI coding tool command line GPT programming")`

Why: Additional terms excludes all pages that don't contain that term. So this inadvertently excludes helpful results that don't happen to contain this exact combination of search terms.


Good: `Web Search("site:github.com (CLI OR terminal OR command-line) (LLM OR AI OR GPT OR Claude) (coding OR programming OR assistant)"`


Bad: `Web Search("shell-gpt cgpt mcpcli terminal ai assistant")`
Why: Unless you're *particularly* interested in pages that mention *all* of these, this needs to be done as separate searches. You could use OR if you want Google to rank the importance of each term, but that doesn't seem to be the intent here.

Bad: `Web Search(""github template repository" testing validation placeholders cookiecutter")`
Why: This contains two of the above mistakes: overly quoted phrases, plus too many terms
Better: `Web Search("github template repository (testing OR validation OR placeholders OR cookiecutter)")`
