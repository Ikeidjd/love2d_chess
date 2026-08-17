#include <stdio.h>

#include "common.h"
#include "board.c"

typedef enum {
    MOVE_NORMAL,
    MOVE_CASTLE,
    MOVE_EN_PASSANT,
    MOVE_PROMOTION,
} MoveType;

typedef struct {
    Pos from;
    Pos to;
} MoveNormal;

typedef struct {
    Pos king_pos;
    bool is_kingside;
} MoveCastle;

typedef struct {
    u8 start_rank;
    u8 start_file;
    u8 end_file;
    u8 piece_type;
} MovePromotion;

typedef struct {
    MoveType type;
    union {
        MoveNormal normal;
        MoveCastle castle;
        MoveNormal en_passant;
        MovePromotion promotion;
    } as;
} Move;

typedef Move MoveBuffer[32];

#define MOVE_INSERT(moves, move_index, move) \
    do { \
        (moves)[(*(move_index))++] = (move); \
    } while (0)

Move move_new_normal(Pos from, Pos to) {
    return (Move) {
        .type = MOVE_NORMAL,
        .as.normal = {
            .from = from,
            .to = to,
        },
    };
}

Move move_new_castle(Pos king_pos, bool is_kingside) {
    return (Move) {
        .type = MOVE_CASTLE,
        .as.castle = {
            .king_pos = king_pos,
            .is_kingside = is_kingside,
        },
    };
}

void move_perform(Board board, CastleInfo* castle_info, Move move) {
    switch (move.type) {
        case MOVE_NORMAL: {
            Piece piece = board_get(board, move.as.normal.from);

            switch (piece) {
                case WHITE_ROOK:
                    if      (pos_eq(move.as.normal.from, (Pos) { .rank = 0, .file = 7 }) || pos_eq(move.as.normal.to, (Pos) { .rank = 0, .file = 7 })) castle_info->can_white_kingside = false;
                    else if (pos_eq(move.as.normal.from, (Pos) { .rank = 0, .file = 0 }) || pos_eq(move.as.normal.to, (Pos) { .rank = 0, .file = 0 })) castle_info->can_white_queenside = false;

                    break;
                case WHITE_KING:
                    if (move.as.normal.from.file == 4) {
                        castle_info->can_white_kingside = false;
                        castle_info->can_white_queenside = false;
                    }

                    break;
                case BLACK_ROOK:
                    if      (pos_eq(move.as.normal.from, (Pos) { .rank = 7, .file = 7 }) || pos_eq(move.as.normal.to, (Pos) { .rank = 7, .file = 7 })) castle_info->can_black_kingside = false;
                    else if (pos_eq(move.as.normal.from, (Pos) { .rank = 7, .file = 0 }) || pos_eq(move.as.normal.to, (Pos) { .rank = 7, .file = 0 })) castle_info->can_black_queenside = false;

                    break;
                case BLACK_KING:
                    if (move.as.normal.from.file == 4) {
                        castle_info->can_black_kingside = false;
                        castle_info->can_black_queenside = false;
                    }

                    break;
                default:
                    break;
            }

            board_set(board, move.as.normal.to, piece);
            board_set(board, move.as.normal.from, EMPTY);

            break;
        }
        case MOVE_CASTLE: {
            Piece king = board_get(board, move.as.castle.king_pos);

            Pos king_from = move.as.castle.king_pos;
            Pos king_to = move.as.castle.king_pos;

            Pos rook_from = move.as.castle.king_pos;
            Pos rook_to = move.as.castle.king_pos;

            if (move.as.castle.is_kingside) {
                king_to.file = king_from.file + 2;
                rook_from.file = 7;
                rook_to.file = king_from.file + 1;
            } else {
                king_to.file = king_from.file - 2;
                rook_from.file = 0;
                rook_to.file = king_from.file - 1;
            }

            Move king_move = move_new_normal(king_from, king_to);
            Move rook_move = move_new_normal(rook_from, rook_to);

            move_perform(board, castle_info, king_move);
            move_perform(board, castle_info, rook_move);

            break;
        }
        case MOVE_EN_PASSANT:
            break;
        case MOVE_PROMOTION:
            break;
    }
}

void move_print(Move move) {
    switch (move.type) {
        case MOVE_NORMAL:
            printf("MoveNormal (from = ");
            pos_print(move.as.normal.from);
            printf(", to = ");
            pos_print(move.as.normal.to);
            printf(")");
            break;
        case MOVE_CASTLE:
            printf("MoveCastle (king_pos = ");
            pos_print(move.as.castle.king_pos);

            if (move.as.castle.is_kingside) {
                printf(", kingside)");
            } else {
                printf(", queenside)");
            }

            break;
        case MOVE_EN_PASSANT:
            printf("MoveEnPassant (from = ");
            pos_print(move.as.en_passant.from);
            printf(", to = ");
            pos_print(move.as.en_passant.to);
            printf(")");
            break;
        case MOVE_PROMOTION:
            printf(
                "MovePromotion (start_rank = %d, start_file = %d, end_file = %d, piece_type = %s)",
                move.as.promotion.start_rank,
                move.as.promotion.start_file,
                move.as.promotion.end_file,
                piece_to_string(move.as.promotion.piece_type)
            );
            break;
    }
}
