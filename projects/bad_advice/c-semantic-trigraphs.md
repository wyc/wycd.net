For this example, compilation with the -trigraphs flag (gcc, or clang in gnu-mode) is required, as in:

	gcc -trigraphs -o test test.c
    
This allows the use of the convenient trigraph operators for error handling! One such operator `??!??!` is pronounced "or else".

Imagine a line in a deeply nested function:

	...
    connect(sockfd, &addr, addrlen) == 0 ??!??! return -1;
    ...
    
Have `connect()` return `0` __or else__ execute `return -1;`

Clear, yet expressive.
