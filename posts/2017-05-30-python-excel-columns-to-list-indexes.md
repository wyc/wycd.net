---
title: Excel Columns to List Indexes in Python
tags: python
---

I was working on some CSV files for a project. I figured that it would be
easier to refer to the columns by their Excel column letters (e.g., 'A', 'B',
'AA', 'AZ') than the column numbers.

Some clear benefits:

- I could refer to the column by how it appeared under LibreOffice, making
  changes easier than matching the exact header string or zero-based
  numbering, both error-prone approaches for me.
- Non-technical team members will know what I'm talking about, as opposed to
  "Column 0"

The snippet is here for anyone who would find it helpful.

```python
def to_idx(letters):
    val = lambda i, x: (26**i) * (ord(x.lower()) - ord('a') + 1)
    return sum([val(i, x) for i, x in enumerate(letters[::-1])]) - 1
```

Here it is in action:

```
    >>> to_idx('A')
    0
    >>> to_idx('AH')
    33
    >>> to_idx('XFD')
    16383
```
