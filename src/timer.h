#ifndef TIMER_H
#define TIMER_H

#if !defined(_POSIX_C_SOURCE) || _POSIX_C_SOURCE < 199309L
#error "must define _POSIX_C_SOURCE >= 199309L"
#endif

#include <time.h>

#define DECLARE_TIMER(X) \
    struct timespec start_time ## X, end_time ## X; \
    time_t dsec ## X; \
    long   dnsec ## X;

#define START_TIMER(X) \
    do {\
    	clock_gettime(CLOCK_MONOTONIC, &start_time ## X);\
    } while(0)

#define END_TIMER(X) \
    do {\
        clock_gettime(CLOCK_MONOTONIC, &end_time ## X); \
        dsec ## X  = end_time ## X.tv_sec - start_time ## X.tv_sec; \
        dnsec ## X = end_time ## X.tv_nsec - start_time ## X.tv_nsec; \
    } while (0)

#define PRINT_TIMER(X) FPRINT_TIMER(stdout, X)

#define FPRINT_TIMER(STREAM, X) \
    fprintf(STREAM, "timer " #X ": %ld ms\n", (dsec ## X * 1000000000 + dnsec ## X)/1000000);

#endif /* TIMER_H */
