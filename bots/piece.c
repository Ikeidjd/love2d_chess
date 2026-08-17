#include "common.h"

typedef enum {
    EMPTY,
    OUT_OF_BOUNDS,
    WHITE_PAWN,
    WHITE_KNIGHT,
    WHITE_BISHOP,
    WHITE_ROOK,
    WHITE_QUEEN,
    WHITE_KING,
    BLACK_PAWN,
    BLACK_KNIGHT,
    BLACK_BISHOP,
    BLACK_ROOK,
    BLACK_QUEEN,
    BLACK_KING,
} Piece;

char* piece_to_string_array[] = {
    [EMPTY] = "--",
    [OUT_OF_BOUNDS] = "OUT_OF_BOUNDS",
    [WHITE_PAWN] = "WP",
    [WHITE_KNIGHT] = "WN",
    [WHITE_BISHOP] = "WB",
    [WHITE_ROOK] = "WR",
    [WHITE_QUEEN] = "WQ",
    [WHITE_KING] = "WK",
    [BLACK_PAWN] = "BP",
    [BLACK_KNIGHT] = "BN",
    [BLACK_BISHOP] = "BB",
    [BLACK_ROOK] = "BR",
    [BLACK_QUEEN] = "BQ",
    [BLACK_KING] = "BK",
};

bool are_friends(Piece lhs, Piece rhs) {
    return lhs > OUT_OF_BOUNDS && rhs > OUT_OF_BOUNDS && (lhs & 8) == (rhs & 8);
}

bool are_enemies(Piece lhs, Piece rhs) {
    return lhs > OUT_OF_BOUNDS && rhs > OUT_OF_BOUNDS && (lhs & 8) != (rhs & 8);
}

Piece color_swap(Piece piece) {
    return piece ^ 8;
}

const char* piece_to_string(Piece piece) {
    return piece_to_string_array[piece];
}