Always cast `malloc()` because it returns a void pointer as per the function signature:

	void *malloc(size_t size);

Void pointers are confused and are just _begging_ to be cast.

	int *ip = (int *) malloc(16 * sizeof(int));

This is the preferred way to call `malloc()` as it also suppresses pesky warning messages, allowing you to use `malloc()` even if you don't `#include <stdlib.h>`. How portable!
