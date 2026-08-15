local Bot = require "bots.Bot"
local Piece = require "Piece"

local BlindGreedBot = {}

Bot:extend(BlindGreedBot, "BlindGreedBot")

function BlindGreedBot:get_best_move(color, board, depth)
    local best_move = nil
    local best_eval = nil

    for pos, piece in board:get_pieces() do
        if piece.color == color then
            piece:generate_moves(pos, board)

            for _, move in piece:get_moves() do
                local board_copy = board:simulate_move(move)
                local evaluation

                if depth == 0 then
                    evaluation = self:eval(board_copy)
                else
                    _, evaluation = self:get_best_move(Piece.get_opposite_color(color), board_copy, depth - 1)
                end

                best_move, best_eval = Bot.best_move_and_eval(best_move, best_eval, move, evaluation, color)
            end
        end
    end

    return best_move, best_eval
end

function BlindGreedBot:eval(board)
    local eval = 0

    for _, piece in board:get_pieces() do
        if piece.color == Piece.WHITE then eval = eval + 1
        else eval = eval - 1 end
    end

    return eval
end

return BlindGreedBot
