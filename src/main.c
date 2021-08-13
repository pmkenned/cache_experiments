#define _POSIX_C_SOURCE 199309L 
#include "timer.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define XSTR(x) STR(x)
#define STR(x) #x

#ifndef NROWS
#define NROWS 100
#endif
#ifndef NCOLS
#define NCOLS 100
#endif

#define DEFAULT_ITER 1000

enum { ROW_MAJOR, COL_MAJOR };

long matrix[NROWS][NCOLS];

static void
usage(const char * program_name)
{
    fprintf(stderr, "\
usage: %s DIR [N]\n\
  DIR:   'row' for row-major, 'col' for column-major\n\
  N:     number of iterations; default: " XSTR(DEFAULT_ITER) "\n\
", program_name);
    exit(EXIT_FAILURE);
}

int main(int argc, char * argv[])
{
    DECLARE_TIMER(1);
    long niter, i, r, c, x;
    int dir;

    if (argc < 2)
        usage(argv[0]);

    if (strcmp(argv[1], "row") == 0)
        dir = ROW_MAJOR;
    else if (strcmp(argv[1], "col") == 0)
        dir = COL_MAJOR;
    else
        usage(argv[0]);

    niter = (argc >= 3) ? strtol(argv[2], NULL, 10) : DEFAULT_ITER;

    printf("NROWS: %d NCOLS: %d (matrix size: %.1f MiB) ; dir: %s-major ; iterations: %ld\n", NROWS, NCOLS, (float)sizeof(matrix)/(1<<20), argv[1], niter);

    START_TIMER(1);
    x = niter;
    for (i = 0; i < niter; i++) {
        if (dir == ROW_MAJOR) {
            for (r = 0; r < NROWS; r++)
                for (c = 0; c < NCOLS; c++)
                    matrix[r][c] = x++;
        } else {
            for (c = 0; c < NCOLS; c++)
                for (r = 0; r < NROWS; r++)
                    matrix[r][c] = x++;
        }
    }
    END_TIMER(1);
    PRINT_TIMER(1);

    return 0;
}
