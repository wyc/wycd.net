___Note to Mobile Users:__ This article is meant for viewing on high-resolution screens as the programming technique described requires one. Please look forward to future articles on mobile coding instead._

In Python, it is customary to use spaces instead of tabs to denote the indentation level of code in a program ([PEP-8](http://www.python.org/dev/peps/pep-0008/)). This leads to the beautiful pythonic code that we all know and love. However, did you know that the next level of indentation doesn't need the same additional spacing as the previous level? That is, the first level of indentation can be 4 spaces in total, but the next level can be 6 spaces instead of 8! Using this principle, we can write some _very_ readable code.

	
    # Column 1      | Column 2         | Column 3
    
    def fizzbuzz():
                      for i in \
                        range(1, 101):
                                         if i % 5 == 0 \
                                          and i % 3 == 0:
                                           print('FizzBuzz')
                                         elif i % 5 == 0:
                                           print('Fizz')
                                         elif i % 3 == 0:
                                           print('Buzz')
                                         else:
                                           print(str(i))
                                           
	fizzbuzz()
    
                              
Above is the innovative three-column Python code format. The function header and invocation are clearly distinct from the function's for loop, and the for loop is clearly distinct from the neatly nestled `if...else` statement. As you may have deduced, this novel technique leverages the horizontal spatial abundance of modern displays.

With screens sporting resolutions of 1600x1200 (or even 1920x1200!), inventive techniques such as the three-column Python code format (TCPCF) must be devised and improved upon to fully take advantage of all screen real estate. Imagine an interpreter dishing out error messages for one of three columns as opposed to one of hundreds of lines--truly efficient.
