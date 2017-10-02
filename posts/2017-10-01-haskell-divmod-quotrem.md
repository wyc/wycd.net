---
title: "Haskell: divMod and quotRem Differences"
tags: haskell, programming
---

`divMod` is integer division and modulo that truncates towards negative
infinity, while `quotRem` is integer division and modulo that behaves like
C-style operators which truncate towards zero.

Here's a visualization that may help explain their differences.

We'll first divide `5` by `2` step by step.

```
steps | value
------+-------
   0  |   5
   1  |   3
   2  |   1  # 5 `divMod` 2 == 5 `quotRem` 2 == (2, 1)
```

The values are the same in this example. However, we now divide `5` by `-2`
step by step.


```
steps | value
------+-------
   0  |   5
  -1  |   3
  -2  |   1  # quotRem stops here. 5 `quotRem` (-2) == (-2, 1)
  -3  |  -1  # divMod stops here. 5 `divMod` (-2) == (-3, -1)
```

One more example, `-14` divided by `5`.

```
steps | value
------+-------
   0  | -14
  -1  |  -9
  -2  |  -4  # quotRem stops here. (-14) `quotRem` 5 == (-2, -4)
  -3  |   1  # divMod stops here. (-14) `divMod` 5 == (-3, 1)
```

The key insight is that while `quotRem` "stops" as soon as remaining value is
less in magnitude than the divisor (the number the dividend is divided by),
`divMod` will happily "cross" its value past zero for the final step if it will
help move the total number of steps towards negative infinity.

For more information see section `6.4.2` of [The Haskell 98
Report](https://www.haskell.org/onlinereport/basic.html).
