#include <stdio.h>

#include "common.h"

typedef struct {
    u8 rank;
    u8 file;
} Pos;

bool pos_eq(Pos lhs, Pos rhs) {
    return lhs.rank == rhs.rank && lhs.file == rhs.file;
}

void pos_print(Pos pos) {
    printf("Pos (rank = %d, file = %d)", pos.rank, pos.file);
}

typedef struct {
    u8 drank;
    u8 dfile;
} Dir;

Pos pos_add_dir(Pos pos, Dir dir) {
    return (Pos) {
        .rank = pos.rank + dir.drank,
        .file = pos.file + dir.dfile,
    };
}

Dir knight_dirs[8] = {
    { .drank = 2, .dfile = 1 },
    { .drank = 2, .dfile = -1 },
    { .drank = -2, .dfile = 1 },
    { .drank = -2, .dfile = -1 },
    { .drank = 1, .dfile = 2 },
    { .drank = -1, .dfile = 2 },
    { .drank = 1, .dfile = -2 },
    { .drank = -1, .dfile = -2 },
};

Dir diagonal_dirs[4] = {
    { .drank = 1, .dfile = 1 },
    { .drank = 1, .dfile = -1 },
    { .drank = -1, .dfile = 1 },
    { .drank = -1, .dfile = -1 },
};

Dir orthogonal_dirs[4] = {
    { .drank = 1, .dfile = 0 },
    { .drank = -1, .dfile = 0 },
    { .drank = 0, .dfile = 1 },
    { .drank = 0, .dfile = -1 },
};

Dir monarch_dirs[8] = {
    { .drank = 1, .dfile = 1 },
    { .drank = 1, .dfile = -1 },
    { .drank = -1, .dfile = 1 },
    { .drank = -1, .dfile = -1 },
    { .drank = 1, .dfile = 0 },
    { .drank = -1, .dfile = 0 },
    { .drank = 0, .dfile = 1 },
    { .drank = 0, .dfile = -1 },
};
