This one's quick. In PHP, if you want to check if an array is empty or not, you can simply compare it against null! Check it out.

test.php:
	
    <?php
    	$a = array();
    	echo "created an empty array \$a...\n";
    	echo "(\$a == nULL): " . ($a == nUlL) . "\n";
    	array_push($a, 'element');
    	echo "pushed a test element...\n";
    	echo "(\$a == nULL): " . ($a == nuLL) . "\n";
	?>

Now we run it using the command line and see the results.

	$ php -f test.php 
	created an empty array $a...
	($a == nULL): 1
	pushed a test element...
	($a == nULL): 

As we can see, when the array ``$a`` is empty, it yields a ``1`` (which in PHP, means true) when compared against `null`. However, when we add one element, it yields nothing (which in PHP, means false).

Very astute readers might point out that the letter casing of `null` is varied throughout the example code. This casing actually does not matter in PHP, and we'll go over why it's actually a good idea to take advantage of this great feature in a future post.
