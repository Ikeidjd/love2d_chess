#include "common.h"
#include "move.c"

void generate_single_moves(Board board, Pos from, MoveBuffer moves, u8* move_index, Dir* dirs, u8 dirs_length) {
    Piece piece_from = board_get(board, from);

    for (u8 i = 0; i < dirs_length; i++) {
        Dir dir = dirs[i];
        Pos to = pos_add_dir(from, dir);
        Piece piece_to = board_get(board, to);

        if (piece_to == EMPTY || are_enemies(piece_from, piece_to)) {
            Move move = move_new_normal(from, to);
            MOVE_INSERT(moves, move_index, move);
        }
    }
}

void generate_sliding_moves(Board board, Pos from, MoveBuffer moves, u8* move_index, Dir* dirs, u8 dirs_length) {
    Piece piece_from = board_get(board, from);

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
    Piece pawn = board_get(board, from);

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
    Piece king = board_get(board, king_pos);

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

    Piece rook = board_get(board, rook_pos);

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
    Piece piece = board_get(board, pos);

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
