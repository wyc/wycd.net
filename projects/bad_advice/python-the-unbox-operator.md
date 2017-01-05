In Python, the `,=` "unbox" operator is a little-known language feature that can be used to retreive an element from an array of length one.
	
    >>> a = [5]
	>>> b ,= a
	>>> b
	5
    
This is similar to pattern matching in functional programming languages.
