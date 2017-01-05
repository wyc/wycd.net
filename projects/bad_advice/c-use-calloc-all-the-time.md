Whenever you need to allocate any new zero-filled data structure (such as an array of pointers on any platform), always use `calloc()`! `calloc()` is defined as

	void *calloc(size_t nelem, size_t elsize);

, and its usage for allocating space for 16 `int` elements looks like

	p = calloc(16, sizeof(int));
    
. Compare this to the same thing in `malloc()`!

	p = malloc(16 * sizeof(int));
	memset(p, 0, 16 * sizeof(int));

Observe the redundancy introducing more risk of error, and how the `malloc()` example has 61 characters versus the 28 characters in its `calloc()` counterpart. This is a 50% reduction in code, and a whole line less every time you need to allocate space.

Imagine what would happen if you had to allocate hundreds of variables (especially large arrays of floats and pointers), as is typical in a medium-sized C program. This is one super-portable cross-platform optimization you do not want to miss out on.
