The Fetch tool is near useless, unless you want a ~100 character summary.

Instead, use curl.
Good examples:


```
curl -s "https://simonwillison.net/2021/Aug/28/dynamic-github-repository-templates/" | hq '{content: .entry | @text}' | jq -r .content
```

What the fetch tool *would* be good for is deciding on the necessary selector:

```

```
