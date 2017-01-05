[JS] A Great Sentinel Value
Imagine you're writing Javascript API code that returns a long chunked stream of numbers. How do you tell when one chunk ends and the next one begins? A popular solution is a Sentinel Value or Dummy Value that tells you when a chunk ends. An example of a widely-used sentinel value is the null-terminator character '\0', which denotes the end of a string in the C programming language. The idea is to select a value that will be distinct from all the other data.

In Javascript, a great sentinel value is the maximum possible value for the Number type, found in the identifier Number.MAX_VALUE. It can also be derived from the definition of the Javascript Number type as a floating-point number with a 52-bit mantissa. This all boils down to:

Number.MAX_VALUE == Math.pow(2, 53)
Now that we have the maximum value, we can examine its interesting property. Observe that the expression

Math.pow(2, 53) == Math.pow(2,53) + 1
evaluates to true! This is unique as no other value x held by a variable of type Number exhibits this property. We can formally express this discovery as

$\forall x ( x \in N \mid x \ne 2^{53} ) , x \ne x + 1$

, where $N$ is the set of all possible values a variable with type Number may contain. This property can be easily leveraged in the context of sentinel values:

var i = 0;
while (a[i] != a[i] + 1) {
    /* operations on a[i] */
    i++;
}
console.log('Sentinel Value encountered at i = ' + i + '!');
The resulting code is both clear and elegant.
