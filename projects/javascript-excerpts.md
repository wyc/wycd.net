---
title: "Excerpts from JavaScript: The Definitive Guide, 6th Edition"
order: 8
---

The book is very well-written! You can thank JavaScript for these interesting bits.

```
"Using the typeof operator on null returns the string ``object'' indicating
that null can be thought of as a special object value that indicates ``no
object.'' In practice, however, null is typically regarded as the sole member
of its own type, and it can be used to indicate ``no value'' for numbers and
strings as well as objects."
       - Page 41

"The equality operator == is like the strict equality operator, but it is less
strict. If the values of the two operands are not the same type, it attempts
some type conversions and tries the comparison again:
- If the two values have the same type, test them for strict equality as
  described above.  If they are strictly equal, they are equal. If they are not
  strictly equal, they are not equal.
- If the two values do not have the same type, the == operator may still
  consider them equal. Use the following rules and type conversions to check
  for equality:
- If one value is null and the other is undefined , they are equal.
- If one value is a number and the other is a string, convert the string to a number
  and try the comparison again, using the converted value.
- If either value is true , convert it to 1 and try the comparison again. If
  either value is false , convert it to 0 and try the comparison again.
- If one value is an object and the other is a number or string, convert
  the object to a primitive using the algorithm described in Â§3.8.3 and try the
  comparison again. An object is converted to a primitive value by either its
  toString() method or its valueOf() method. The built-in classes of core
  JavaScript attempt valueOf() conversion before toString() conversion, except
  for the Date class, which performs toString() conversion. Objects that are not
  part of core Java- Script may convert themselves to primitive values in an
  implementation-defined way.
- Any other combinations of values are not equal."
        - Page 72

"Note that typeof returns ``object'' if the operand value is null"
        - Page 83

"delete expects its operand to be an lvalue. If it is not an lvalue, the
operator takes no action and returns true . Otherwise, delete attempts to
delete the specified lvalue.  delete returns true if it successfully deletes
the specified lvalue."
        - Page 84

"The rules are not completely straightforward, however. It is possible to
change the value of a nonwritable property if that property is configurable,
for example. Also, it is possible to change a property from writable to
nonwritable even if that property is nonconfigurable."
        - Page 133

"So to obtain the class of an object, you can invoke this toString() method on
it, and extract the eighth through the second-to-last characters of the
returned string. The tricky part is that many objects inherit other, more
useful toString() methods, and to invoke the correct version of toString() , we
must do so indirectly, using the Function.call() method (see Â§8.7.3)."
        - Page 136

"If you define your own constructor function, any objects you create with it
will have a class attribute of ``Object'': there is no way to specify the class
attribute for your own classes of objects"
        - Page 136

"Note that you can index an array using numbers that are negative or that are
not inte- gers. When you do this, the number is converted to a string, and that
string is used as the property name."
        - Page 143

"Normally, the length property of an array specifies the number of elements in
the array. If the array is sparse, the value of the length property is greater
than the number of elements."
        - Page 144

The many colorful ways to iterate arrays.
        - Pages 146, 147, 148

"To sort an array into some order other than alphabetical, you must pass a
comparison function as an argument to sort() ."
        - Page 149


"Constructor functions do not normally use the return keyword. They typically
initialize the new object and then return implicitly when they reach the end of
their body. In this case, the new object is the value of the constructor
invocation expression. If, however, a constructor explicitly used the return
statement to return an object, then that object becomes the value of the
invocation expression. If the constructor uses return with no value, or if it
returns a primitive value, that return value is ignored and the new object is
used as the value of the invocation."
	- Page 170

"The Arguments object has one very unusual feature. In non-strict mode, when a
function has named parameters, the array elements of the Arguments object are
aliases for the parameters that hold the function arguments. The numbered
elements of the Arguments object and the parameter names are like two different
names for the same variable. Changing the value of an argument with an argument
name changes the value that is retrieved through the arguments[] array.
Conversely, changing the value of an argument through the arguments[] array
changes the value that is retrieved by the argument name."
	- Page 173

"The caller property gives access to the call stack, and the callee
property is occasionally useful to allow unnamed functions to call themselves
recursively"
	- Page 173

If you want to determine whether an object is a true function object (and has
function methods) you can test its class attribute (Â§6.8.2) using te technique
shown in Example 6-4:
    function isFunction(x) {
        return Object.prototype.toString.call(x) === "[object Function]";
    }
        - Page 191
```
