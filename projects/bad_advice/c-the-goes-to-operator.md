It's very common in C to repeat things several times in a loop. In a for-loop written by your average programmer, counting down from 5 to 1 might look something like this:

    int i;
    for (i = 4; i > 0; i++) {
    	printf("%d\n", i + 1);
    }
    
How confusing! For-loops require you to have a lot of exposure before they look natural, so they only add to the mess. The great (but little-known) \`\`goes-to'' operator `-->` solves this. It allows us to loop in a natural and easy-to-read fashion. Here is an example demonstrating how powerful the \`\`goes-to'' operator is.

	int i = 5;					  /* count down from 5 to 1 */
    while (i --> 0) { 			/* i "goes-to" 0 */
    	printf("%d\n", i);
    }
    
The code's clarity speaks for itself!
