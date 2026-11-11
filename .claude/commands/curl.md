---
description: Fetch full web content via curl + hq (Fetch tool only summarizes)
argument-hint: "[url]"
---

The Fetch tool is near useless, unless you want a ~100 character summary.

Instead, use curl.

Prefer the page's source over its HTML: docs sites often link "Edit this
page" / "Edit on GitHub"; curl that file raw instead
(`github.com/ORG/REPO/edit/BRANCH/PATH` →
`raw.githubusercontent.com/ORG/REPO/BRANCH/PATH`).

Otherwise, extract the content from the HTML.
Good examples:


```
curl -s "https://simonwillison.net/2021/Aug/28/dynamic-github-repository-templates/" | hq '{content: .entry | @text}' | jq -r .content
```

What the fetch tool *would* be good for is finding that edit link, or deciding on the necessary selector:

```

```
