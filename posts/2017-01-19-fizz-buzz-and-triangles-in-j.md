---
title: FizzBuzz in J, Explained
tags: jlang, software, programming
description: Two common programming challenges in a tacit programming style.
---

Jeff Atwood famously wrote about [FizzBuzz](https://blog.codinghorror.com/why-cant-programmers-program/) and how so many self-proclaimed programmers struggle with it. Let's solve two such interview screener questions in [J](http://jsoftware.com), the open-source [APL](https://en.wikipedia.org/wiki/APL_(programming_language)) descendant! I'll try my best to describe my train of thought, and how I piece together the solution step-by-step, as reactions to J code samples range from "WTF?!?!?!" to "it looks like your cat chewed on your 56k line". If you're not familiar with J, it's best to also be looking at the [J vocab page](http://www.jsoftware.com/help/dictionary/vocabul.htm) while reading this. If you want to start learning from scratch, [this tutorial](http://www.jsoftware.com/help/learning/01.htm) may be your best bet. On that note, here's my solution to FizzBuzz:

## FizzBuzz

### The Full Answer

> Write a program that prints the numbers from 1 to 100. But for multiples of three print “Fizz” instead of the number and for the multiples of five print “Buzz”. For numbers which are multiples of both three and five print “FizzBuzz”.

```j
NB. FizzBuzz
FB=:('FizzBuzz';'Fizz';'Buzz';":){::~0 i.~15 3 5|]
FB"0 >:i.100
```

It may seem a little strange if you're not familiar with array languages and [tacit programming](https://en.wikipedia.org/wiki/Tacit_programming), but assuredly, you can see how the `15 3 5` might correspond to `'FizzBuzz';'Fizz';'Buzz'`. Getting there is the fun!

This is how the interpreter builds its syntax tree for the expression `FB`:

```
jconsole> 5!:4 <'FB'

        ┌─ 'FizzBuzz'                  
        ├─ ;                           
  ┌─────┤            ┌─ 'Fizz'         
  │     │            ├─ ;              
  │     └────────────┤        ┌─ 'Buzz'
  │                  └────────┼─ ;     
  │                           └─ ":    
──┼─ ~ ─── {::                         
  │                                    
  │     ┌─ 0                           
  │     ├─ ~ ────────── i.             
  └─────┤                              
        │            ┌─ 15 3 5         
        └────────────┼─ |              
                     └─ ]     

```


### The Choices
First up, we have `('FizzBuzz';'Fizz';'Buzz';":)`. The operator `;` is very similar to [`cons` in Lisp](http://www.lispworks.com/documentation/lw70/CLHS/Body/f_cons.htm). It's pretty apparent from the syntax tree that this is a close representation! The first elements are strings. The last element, `":`, is a function that will print a given value and must be applied before the "list" formation can occur. The `{::` operator retrieves a value from our "list" just as [`elem` in Haskell](https://hackage.haskell.org/package/base-4.9.1.0/docs/Prelude.html#v:elem) does. In J, lists of the same atom type are best represented as arrays, and lists of mixed atom types must be represented by boxes. More details on this can be found [here](http://www.jsoftware.com/help/dictionary/dicta.htm).

```j
jconsole>    ('FizzBuzz';'Fizz';'Buzz';":) 1337
┌────────┬────┬────┬────┐
│FizzBuzz│Fizz│Buzz│1337│
└────────┴────┴────┴────┘
jconsole> 0{::(('FizzBuzz';'Fizz';'Buzz';":) 1337)
FizzBuzz
jconsole> 1{::(('FizzBuzz';'Fizz';'Buzz';":) 1337)
Fizz
jconsole> 2{::(('FizzBuzz';'Fizz';'Buzz';":) 1337)
Buzz
jconsole> 3{::(('FizzBuzz';'Fizz';'Buzz';":) 1337)
1337
jconsole> 4{::(('FizzBuzz';'Fizz';'Buzz';":) 1337)
|index error
|   4    {::(('FizzBuzz';'Fizz';'Buzz';":)1337)
```

The `~` commutes, or switches, the operands of `{::`, `x {::~ y ↔ y {:: x`. This is what [`flip` does in Haskell](https://hackage.haskell.org/package/base-4.9.1.0/docs/Prelude.html#v:flip).

```j
jconsole> (('FizzBuzz';'Fizz';'Buzz';":) 1337){::~0
FizzBuzz
jconsole> (('FizzBuzz';'Fizz';'Buzz';":) 1337){::~1
Fizz
jconsole> (('FizzBuzz';'Fizz';'Buzz';":) 1337){::~2
Buzz
jconsole> (('FizzBuzz';'Fizz';'Buzz';":) 1337){::~3
1337
```

### The Selector Expression

Now let's look at the second half of this expression, `(0 i.~15 3 5|])`. We can feed it some values like this:

```j
jconsole> a=:(0 i.~15 3 5|])
jconsole> a 15
0
jconsole> a 3
1
jconsole> a 5
2
jconsole> a 30
0
jconsole> a 6
1
jconsole> a 10
2
jconsole> a 1
3
jconsole> a 2
3
jconsole> a 4
3
```

Its behavior can be summarized by this sequential algorithm:

1. If divisible by 15, return 0
2. If divisible by 3, return 1
3. If divisible by 5, return 2
4. Otherwise, return 3

This is exactly what we need to select from the choices described above! Let's look at how this algorithm is implemented. First, the subexpression `15 3 5|]`. We will ignore the `]` for now, which is kind of like an identity function, and frequently used for tacit programming in J in the same vein that [`$` is used in Haskell](http://learnyouahaskell.com/higher-order-functions). If you're interested in how `]` is relevant to the larger expression, you can read about verb evaluation patterns in J [here](http://www.jsoftware.com/help/learning/09.htm). The new expression is now `15 3 5|`:

```j
jconsole> 15 3 5|15
0 0 0
jconsole> 15 3 5|15
0 0 0
jconsole> 15 3 5|3
3 0 3
jconsole> 15 3 5|5
5 2 0
jconsole> 15 3 5|30
0 0 0
jconsole> 15 3 5|6
6 0 1
jconsole> 15 3 5|10
10 1 0
jconsole> 15 3 5|1
1 1 1
```

`|` is the modulo operator, as it is in many other languages. However, because J is an array language, the operator affects all elements much like in Matlab or R. From here, we can see that we're closer to an implementation of the described algorithm:

1. Pick the index of the first zero from the above modulo application
2. Otherwise, return the length of the array


`i.` is the key to this. It's synonymous with an infixed [`elemIndex` in Haskell](https://hackage.haskell.org/package/base-4.2.0.0/docs/Data-List.html#v%3AelemIndex) or [`indexOf` in JavaScript](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/indexOf), with the exception of returning the length of the array if not present instead of `Nothing` or `-1`.

```j
jconsole> 11 12 13 i. 11
0
jconsole> 11 12 13 i. 12
1
jconsole> 11 12 13 i. 13
2
jconsole> 11 12 13 i. 14
3
jconsole> 11 12 13 i. 1
3
```

Now we have most of the components needed for a rough understanding of how this function works!

```
NB. FizzBuzz
FB=:('FizzBuzz';'Fizz';'Buzz';":){::~0 i.~15 3 5|]
FB"0 >:i.100
```

## Triangle Type

Let's look at another short screener problem.

> Given 3 positive integer lengths to represent the sides of a triangle write a program that will determine the type of triangle: equilateral, isosceles, irregular, or impossible.

We will solve it in fewer characters than the original prompt, though that's not our main goal.

```j
jconsole> trigsort =:('Equilateral';'Isoceles';'Irregular';'Impossible'){::~3&,@<:@#@~.{~2&*@(>./)<+/
jconsole> trigsort 1 1 1
Equilateral
jconsole> trigsort 1 1 2
Impossible
jconsole> trigsort 1 2 2
Isoceles
jconsole> trigsort 3 4 5
Irregular
```

I'll give a _brief_ overview of some subcomponents.

```
NB. Map of the results
trigtype=:('Equilateral';'Isoceles';'Irregular';'Impossible') {::~ ]

NB. Given an array of three numbers, return how many different values there are, minus one
numtype =: <:@#@~.

NB. Given an array of three positive numbers, test for the triangle inequality, returning 1 if it holds and 0 otherwise
validtrig =: 2&*@(>./) < +/

NB. Put everything together
trigsort =: trigtype ((3&,@numtype) {~ validtrig)
```

It could probably be cleaned up even more, but I'm okay with how it is right now.

Thank you `b_jonas` for improving on my kludge of `numtype =:9 5 3 i. +/@;@(=/])`


## Why do this

Why use J at all if it appears so unmaintainable? Well, maybe math looks unmaintainable too upon first glance. Or Chinese, or Arabic. J _excels_ at representing high-dimensional computations (*ahem machine learning _barfs_*) and has a very high density of algorithmic meaning. Doesn't it make sense that in mathematics, we use the integral symbol instead of `A.Integral(B)`? IMHO, J and other languages in this family such as K, Q, and APL invent such a notation for computation. For example, here's naive K-nearest neighbors implemented in J:

```
NB. naive k-nearest neighbors in J

dist =: [:%:[:|[:+/(*:@:-)    NB. dyad takes two vectors, returns euclidean distance

data =: 1 2 3,2 2 3,2 3 3,1 2 3,:2 3 4
query =: 1 2 3
k =: 3

k {."1 /:"1 query&dist"1 data
```

It does get easier. The operators start coming together as letters do to form words. The works of experienced others start reading like prose. It's definitely a new experience, and I find it worthwhile.

If you have more questions, there's a wonderful IRC community in `#jsoftware` on freenode.
