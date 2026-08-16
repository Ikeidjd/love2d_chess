#include <stdio.h>
#include <stdbool.h>
#include <string.h>

#define BOARD_SIZE 8

typedef unsigned char u8;
typedef u8 Board[8][4]; // 4 files instead of 8 because each nybble of a u8 holds two pieces

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
} PieceType;

char* piece_type_to_string[] = {
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

bool are_enemies(PieceType lhs, PieceType rhs) {
    return lhs > OUT_OF_BOUNDS && rhs > OUT_OF_BOUNDS && (lhs & 8) != (rhs & 8);
}

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

Dir knight_dirs[] ={
    { .drank = 2, .dfile = 1 },
    { .drank = 2, .dfile = -1 },
    { .drank = -2, .dfile = 1 },
    { .drank = -2, .dfile = -1 },
    { .drank = 1, .dfile = 2 },
    { .drank = -1, .dfile = 2 },
    { .drank = 1, .dfile = -2 },
    { .drank = -1, .dfile = -2 },
};

Dir diagonal_dirs[] = {
    { .drank = 1, .dfile = 1 },
    { .drank = 1, .dfile = -1 },
    { .drank = -1, .dfile = 1 },
    { .drank = -1, .dfile = -1 },
};

Dir orthogonal_dirs[] = {
    { .drank = 1, .dfile = 0 },
    { .drank = -1, .dfile = 0 },
    { .drank = 0, .dfile = 1 },
    { .drank = 0, .dfile = -1 },
};

Dir monarch_dirs[] = {
    { .drank = 1, .dfile = 1 },
    { .drank = 1, .dfile = -1 },
    { .drank = -1, .dfile = 1 },
    { .drank = -1, .dfile = -1 },
    { .drank = 1, .dfile = 0 },
    { .drank = -1, .dfile = 0 },
    { .drank = 0, .dfile = 1 },
    { .drank = 0, .dfile = -1 },
};

Pos pos_add_dir(Pos pos, Dir dir) {
    return (Pos) {
        .rank = pos.rank + dir.drank,
        .file = pos.file + dir.dfile,
    };
}

PieceType board_get(Board board, Pos pos) {
    if (pos.rank < 0 || pos.rank >= BOARD_SIZE || pos.file < 0 || pos.file >= BOARD_SIZE) return OUT_OF_BOUNDS;

    u8 file_index = pos.file >> 1;
    u8 shift_amount = !(pos.file & 1) << 2;

    u8 cell = board[pos.rank][file_index];
    return (cell >> shift_amount) & 0xF;
}

void board_set(Board board, Pos pos, PieceType piece) {
    if (pos.rank < 0 || pos.rank >= BOARD_SIZE || pos.file < 0 || pos.file >= BOARD_SIZE) return;

    u8 file_index = pos.file >> 1;
    u8 shift_amount = !(pos.file & 1) << 2;

    u8 mask_and = 0xF0 >> shift_amount; // This one empties out the nybble to be set (by using & to keep only the other one)
    u8 mask_or = piece << shift_amount; // This one sets it (by using | after it was emptied out)

    board[pos.rank][file_index] &= mask_and;
    board[pos.rank][file_index] |= mask_or;
}

void board_print(Board board) {
    for (u8 rank = 0; rank < BOARD_SIZE; rank++) {
        for (u8 file = 0; file < BOARD_SIZE; file++) {
            Pos pos = {
                .rank = BOARD_SIZE - rank - 1,
                .file = file,
            };

            printf("%s ", piece_type_to_string[board_get(board, pos)]);
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

Board global_board;

typedef struct {
    bool can_white_kingside;
    bool can_white_queenside;
    bool can_black_kingside;
    bool can_black_queenside;
} CastleInfo;

CastleInfo global_castle_info = {
    .can_white_kingside = true,
    .can_white_queenside = true,
    .can_black_kingside = true,
    .can_black_queenside = true,
};

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
            PieceType piece = board_get(board, move.as.normal.from);

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
            PieceType king = board_get(board, move.as.castle.king_pos);

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
                piece_type_to_string[move.as.promotion.piece_type]
            );
            break;
    }
}

#define MOVE_INSERT(moves, move_index, move) \
    do { \
        (moves)[(*(move_index))++] = (move); \
    } while (0)

void generate_single_moves(Board board, Pos from, MoveBuffer moves, u8* move_index, Dir* dirs, u8 dirs_length) {
    PieceType piece_from = board_get(board, from);

    for (u8 i = 0; i < dirs_length; i++) {
        Dir dir = dirs[i];
        Pos to = pos_add_dir(from, dir);
        PieceType piece_to = board_get(board, to);

        if (piece_to == EMPTY || are_enemies(piece_from, piece_to)) {
            Move move = move_new_normal(from, to);
            MOVE_INSERT(moves, move_index, move);
        }
    }
}

void generate_sliding_moves(Board board, Pos from, MoveBuffer moves, u8* move_index, Dir* dirs, u8 dirs_length) {
    PieceType piece_from = board_get(board, from);

    for (u8 i = 0; i < dirs_length; i++) {
        Dir dir = dirs[i];
        Pos to = pos_add_dir(from, dir);

        while (board_get(board, to) == EMPTY) {
            Move move = move_new_normal(from, to);
            MOVE_INSERT(moves, move_index, move);
            to = pos_add_dir(to, dir);
        }

        if (are_enemies(piece_from, board_get(board, to))) {
            Move move = move_new_normal(from, to);
            MOVE_INSERT(moves, move_index, move);
        }
    }
}

void generate_basic_pawn_moves_and_captures(Board board, Pos from, MoveBuffer moves, u8* move_index) {
    PieceType pawn = board_get(board, from);

    u8 starting_rank;
    Dir forward;

    if (pawn == WHITE_PAWN) {
        starting_rank = 1;

        forward = (Dir) {
            .drank = 1,
            .dfile = 0,
        };
    } else {
        starting_rank = 6;

        forward = (Dir) {
            .drank = -1,
            .dfile = 0,
        };
    }

    Pos to = pos_add_dir(from, forward);

    // Captures
    Pos capture = pos_add_dir(to, (Dir) { .drank = 0, .dfile = -1 });

    if (are_enemies(pawn, board_get(board, capture))) {
        Move move = move_new_normal(from, capture);
        MOVE_INSERT(moves, move_index, move);
    }

    capture = pos_add_dir(to, (Dir) { .drank = 0, .dfile = 1 });

    if (are_enemies(pawn, board_get(board, capture))) {
        Move move = move_new_normal(from, capture);
        MOVE_INSERT(moves, move_index, move);
    }

    // Moves
    if (board_get(board, to) == EMPTY) {
        Move move = move_new_normal(from, to);
        MOVE_INSERT(moves, move_index, move);
        to = pos_add_dir(to, forward);

        if (from.rank == starting_rank && board_get(board, to) == EMPTY) {
            Move move = move_new_normal(from, to);
            MOVE_INSERT(moves, move_index, move);
        }
    }
}

void generate_castle(Board board, CastleInfo castle_info, Pos king_pos, MoveBuffer moves, u8* move_index, bool is_kingside) {
    PieceType king = board_get(board, king_pos);

    if (king == WHITE_KING) {
        if (is_kingside && !castle_info.can_white_kingside) return;
        if (!is_kingside && !castle_info.can_white_queenside) return;
    } else {
        if (is_kingside && !castle_info.can_black_kingside) return;
        if (!is_kingside && !castle_info.can_black_queenside) return;
    }

    Dir dir;

    if (is_kingside) {
        dir = (Dir) {
            .drank = 0,
            .dfile = 1,
        };
    } else {
        dir = (Dir) {
            .drank = 0,
            .dfile = -1,
        };
    }

    Pos rook_pos = pos_add_dir(king_pos, dir);

    while (board_get(board, rook_pos) == EMPTY) {
        rook_pos = pos_add_dir(rook_pos, dir);
    }

    PieceType rook = board_get(board, rook_pos);

    // If the rook and the king never move, then the flag that determines if castling is possible remains true, even if the rook is captured
    // This means that if we just did (rook == WHITE_ROOK || rook == BLACK_ROOK), an unmoved white king could castle with a black rook that captured an unmoved white rook
    // The same applies to the opposite colors
    // Doing (king - rook == WHITE_KING - WHITE_ROOK) makes sure the king can only castle with a rook of the same color, preventing this problem
    if (king - rook == WHITE_KING - WHITE_ROOK) {
        Move move = move_new_castle(king_pos, is_kingside);
        MOVE_INSERT(moves, move_index, move);
    }
}

void generate_moves(Board board, CastleInfo castle_info, Pos pos, MoveBuffer moves, u8* move_index) {
    PieceType piece = board_get(board, pos);

    switch (piece) {
        case EMPTY:
        case OUT_OF_BOUNDS:
            break;
        case WHITE_PAWN:
        case BLACK_PAWN:
            generate_basic_pawn_moves_and_captures(board, pos, moves, move_index);
            break;
        case WHITE_KNIGHT:
        case BLACK_KNIGHT:
            generate_single_moves(board, pos, moves, move_index, knight_dirs, sizeof(knight_dirs) / sizeof(knight_dirs[0]));
            break;
        case WHITE_BISHOP:
        case BLACK_BISHOP:
            generate_sliding_moves(board, pos, moves, move_index, diagonal_dirs, sizeof(diagonal_dirs) / sizeof(diagonal_dirs[0]));
            break;
        case WHITE_ROOK:
        case BLACK_ROOK:
            generate_sliding_moves(board, pos, moves, move_index, orthogonal_dirs, sizeof(orthogonal_dirs) / sizeof(orthogonal_dirs[0]));
            break;
        case WHITE_QUEEN:
        case BLACK_QUEEN:
            generate_sliding_moves(board, pos, moves, move_index, monarch_dirs, sizeof(monarch_dirs) / sizeof(monarch_dirs[0]));
            break;
        case WHITE_KING:
        case BLACK_KING:
            generate_single_moves(board, pos, moves, move_index, monarch_dirs, sizeof(monarch_dirs) / sizeof(monarch_dirs[0]));
            generate_castle(board, castle_info, pos, moves, move_index, true);
            generate_castle(board, castle_info, pos, moves, move_index, false);
            break;
    }
}

int main(int argc, char** argv) {
    memcpy(global_board, castle_test_board, sizeof(global_board) / sizeof(global_board[0][0]));

    while (true) {
        board_print(global_board);

        char c;
        scanf("%c", &c);

        switch (c) {
            // 't' for "teleport"
            case 't': {
                int rank, file;

                printf("from:\n    rank: ");
                fflush(stdout);
                scanf("%d", &rank);

                printf("    file: ");
                fflush(stdout);
                scanf("%d", &file);

                Pos from = {
                    .rank = rank,
                    .file = file,
                };

                printf("to:\n    rank: ");
                fflush(stdout);
                scanf("%d", &rank);

                printf("    file: ");
                fflush(stdout);
                scanf("%d", &file);

                Pos to = {
                    .rank = rank,
                    .file = file,
                };

                Move move = move_new_normal(from, to);
                move_perform(global_board, &global_castle_info, move);

                break;
            }
            // 'g' for "generate moves"
            case 'g': {
                int rank, file;

                printf("rank: ");
                fflush(stdout);
                scanf("%d", &rank);

                printf("file: ");
                fflush(stdout);
                scanf("%d", &file);

                Pos pos = {
                    .rank = rank,
                    .file = file,
                };

                MoveBuffer moves;
                u8 move_index = 0;

                generate_moves(global_board, global_castle_info, pos, moves, &move_index);

                printf("%d moves\n", move_index);

                for (u8 i = 0; i < move_index; i++) {
                    printf("%d - ", i + 1);
                    move_print(moves[i]);
                    printf("\n");
                }

                int i;

                printf("Choose the move to perform (0 to cancel): ");
                fflush(stdout);
                scanf("%d", &i);

                if (i > 0) {
                    move_perform(global_board, &global_castle_info, moves[i - 1]);
                }

                break;
            }
            // 'q' for "quit"
            case 'q':
                return 0;
        }
    }

    return 0;
}
