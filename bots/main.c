#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#include "move_generation.c"

double board_eval(Board board, Piece color) {
    double eval = 0;

    for (u8 rank = 0; rank < BOARD_SIZE; rank++) {
        for (u8 file = 0; file < BOARD_SIZE; file++) {
            Pos pos = {
                .rank = rank,
                .file = file,
            };

            Piece piece = board_get(board, pos);

            switch (piece) {
                case WHITE_PAWN:
                    eval++;
                    break;
                case WHITE_KNIGHT:
                case WHITE_BISHOP:
                    eval += 3;
                    break;
                case WHITE_ROOK:
                    eval += 5;
                    break;
                case WHITE_QUEEN:
                    eval += 9;
                    break;
                case WHITE_KING:
                    eval += 100;
                    break;
                case BLACK_PAWN:
                    eval--;
                    break;
                case BLACK_KNIGHT:
                case BLACK_BISHOP:
                    eval -= 3;
                    break;
                case BLACK_ROOK:
                    eval -= 5;
                    break;
                case BLACK_QUEEN:
                    eval -= 9;
                    break;
                case BLACK_KING:
                    eval -= 100;
                    break;
                default:
                    break;
            }
        }
    }

    return are_friends(WHITE_PAWN, color) ? eval : -eval;
}

Board global_board;

CastleInfo global_castle_info = {
    .can_white_kingside = true,
    .can_white_queenside = true,
    .can_black_kingside = true,
    .can_black_queenside = true,
};

typedef struct {
    Move move;
    double eval;
} MoveEval;

MoveEval get_best_move(Board board, CastleInfo castle_info, Piece color, size_t depth, double alpha, double beta) {
    if (depth == 0) {
        return (MoveEval) {
            .move = {},
            .eval = board_eval(board, color),
        };
    }

    MoveEval out = {
        .move = {},
        .eval = -1.0 / 0.0,
    };

    for (u8 rank = 0; rank < BOARD_SIZE; rank++) {
        for (u8 file = 0; file < BOARD_SIZE; file++) {
            Pos pos = {
                .rank = rank,
                .file = file,
            };

            Piece piece = board_get(board, pos);

            if (!are_friends(piece, color)) continue;

            MoveBuffer moves;
            u8 move_index = 0;

            generate_moves(board, castle_info, pos, moves, &move_index);

            for (u8 i = 0; i < move_index; i++) {
                Board copy;
                board_copy(copy, board);

                CastleInfo castle_info_copy = castle_info;

                Move move = moves[i];
                move_perform(copy, &castle_info_copy, move);

                // This way, even in the unluckiest case, there will always be a move
                if (out.eval == -1.0 / 0.0) out.move = move;

                // How to make it faster? Just discard random moves
                if (rand() % 2 == 0) continue;

                MoveEval move_eval = get_best_move(copy, castle_info_copy, color_swap(color), depth - 1, -beta, -alpha);
                move_eval.eval = -move_eval.eval;

                if (move_eval.eval > beta) return move_eval;

                if (move_eval.eval > out.eval) {
                    out.move = move;
                    out.eval = move_eval.eval;
                }

                if (out.eval > alpha) alpha = out.eval;
            }
        }
    }

    return out;
}

int main(int argc, char** argv) {
    srand(time(NULL));

    board_copy(global_board, normal_board);

    Piece color = WHITE_PAWN;

    while (true) {
        board_print(global_board);

        MoveEval best_move_eval = get_best_move(global_board, global_castle_info, color, 6, -1.0 / 0.0, 1.0 / 0.0);
        printf("EVAL: %f, MOVE: ", best_move_eval.eval);
        move_print(best_move_eval.move);
        printf("\n");

        color = color_swap(color);

        char c = '\n';
        while (c == '\n') scanf("%c", &c);

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
            case 'b':
                move_perform(global_board, &global_castle_info, best_move_eval.move);
                break;
            // 'q' for "quit"
            case 'q':
                return 0;
        }
    }

    return 0;
}
