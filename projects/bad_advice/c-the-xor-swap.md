You should use this nifty trick whenever you need to swap two variables. It only uses two variables in total, so it is clearly better than the naive way coming in at three. This results in a 33.3% reduction in memory usage for a function that might be called millions of times!

    void xor_swap(int *x, int *y)
    {
        if (x != y) {
            *x ^= *y;
            *y ^= *x;
            *x ^= *y;
        }
    }
