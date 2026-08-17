#include <stdio.h>
#include <string.h>

#include "common.h"
#include "location.c"
#include "piece.c"

#define BOARD_SIZE 8
typedef u8 Board[BOARD_SIZE][BOARD_SIZE / 2]; // BOARD_SIZE / 2 files instead of BOARD_SIZE because each nybble of a u8 holds two pieces

typedef struct {
    bool can_white_kingside;
    bool can_white_queenside;
    bool can_black_kingside;
    bool can_black_queenside;
} CastleInfo;

Piece board_get(Board board, Pos pos) {
    if (pos.rank < 0 || pos.rank >= BOARD_SIZE || pos.file < 0 || pos.file >= BOARD_SIZE) return OUT_OF_BOUNDS;

    u8 file_index = pos.file >> 1;
    u8 shift_amount = !(pos.file & 1) << 2;

    u8 cell = board[pos.rank][file_index];
    return (cell >> shift_amount) & 0xF;
}

void board_set(Board board, Pos pos, Piece piece) {
    if (pos.rank < 0 || pos.rank >= BOARD_SIZE || pos.file < 0 || pos.file >= BOARD_SIZE) return;

    u8 file_index = pos.file >> 1;
    u8 shift_amount = !(pos.file & 1) << 2;

    u8 mask_and = 0xF0 >> shift_amount; // This one empties out the nybble to be set (by using & to keep only the other one)
    u8 mask_or = piece << shift_amount; // This one sets it (by using | after it was emptied out)

    board[pos.rank][file_index] &= mask_and;
    board[pos.rank][file_index] |= mask_or;
}

void board_copy(Board copy, Board original) {
    memcpy(copy, original, 32);
}

void board_print(Board board) {
    for (u8 rank = 0; rank < BOARD_SIZE; rank++) {
        for (u8 file = 0; file < BOARD_SIZE; file++) {
            Pos pos = {
                .rank = BOARD_SIZE - rank - 1,
                .file = file,
            };

            printf("%s ", piece_to_string(board_get(board, pos)));
        }

        printf("\n");
    }
}

Board normal_board = {
    {(WHITE_ROOK << 4) | WHITE_KNIGHT, (WHITE_BISHOP << 4) | WHITE_QUEEN, (WHITE_KING << 4) | WHITE_BISHOP, (WHITE_KNIGHT << 4) | WHITE_ROOK},
    {(WHITE_PAWN << 4) | WHITE_PAWN, (WHITE_PAWN << 4) | WHITE_PAWN, (WHITE_PAWN << 4) | WHITE_PAWN, (WHITE_PAWN << 4) | WHITE_PAWN},
    {EMPTY},
    {EMPTY},
    {EMPTY},
    {EMPTY},
    {(BLACK_PAWN << 4) | BLACK_PAWN, (BLACK_PAWN << 4) | BLACK_PAWN, (BLACK_PAWN << 4) | BLACK_PAWN, (BLACK_PAWN << 4) | BLACK_PAWN},
    {(BLACK_ROOK << 4) | BLACK_KNIGHT, (BLACK_BISHOP << 4) | BLACK_QUEEN, (BLACK_KING << 4) | BLACK_BISHOP, (BLACK_KNIGHT << 4) | BLACK_ROOK},
};

Board pawnless_board = {
    {(WHITE_ROOK << 4) | WHITE_KNIGHT, (WHITE_BISHOP << 4) | WHITE_QUEEN, (WHITE_KING << 4) | WHITE_BISHOP, (WHITE_KNIGHT << 4) | WHITE_ROOK},
    {EMPTY},
    {EMPTY},
    {EMPTY},
    {EMPTY},
    {EMPTY},
    {EMPTY},
    {(BLACK_ROOK << 4) | BLACK_KNIGHT, (BLACK_BISHOP << 4) | BLACK_QUEEN, (BLACK_KING << 4) | BLACK_BISHOP, (BLACK_KNIGHT << 4) | BLACK_ROOK},
};

Board castle_test_board = {
    {(WHITE_ROOK << 4) | EMPTY, (EMPTY << 4) | EMPTY, (WHITE_KING << 4) | EMPTY, (EMPTY << 4) | WHITE_ROOK},
    {EMPTY},
    {EMPTY},
    {EMPTY},
    {EMPTY},
    {EMPTY},
    {EMPTY},
    {(BLACK_ROOK << 4) | EMPTY, (EMPTY << 4) | EMPTY, (BLACK_KING << 4) | EMPTY, (EMPTY << 4) | BLACK_ROOK},
};
