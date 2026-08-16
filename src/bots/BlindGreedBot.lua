local Bot = require "bots.Bot"
local Piece = require "Piece"

local BlindGreedBot = {}

Bot:extend(BlindGreedBot, "BlindGreedBot")

function BlindGreedBot:get_best_eval(color, board, depth, alpha, beta)
    if depth == 0 then return nil, self:eval(color, board) end

    local best_move = nil
    local best_eval = -1 / 0

    for pos, piece in board:get_pieces() do
        if piece.color == color then
            piece:generate_moves(pos, board)

            for _, move in piece:get_moves() do
                local board_copy = board:simulate_move(move)

                local _, eval = self:get_best_eval(Piece.get_opposite_color(color), board_copy, depth - 1, -beta, -alpha)
                eval = -eval

                if eval > best_eval then
                    best_move, best_eval = move, eval
                end

                alpha = math.max(alpha, eval)
            end

            if best_eval >= beta then break end
        end
    end

    return best_move, best_eval
end

function BlindGreedBot:eval(color, board)
    local eval = 0

    for _, piece in board:get_pieces() do
        if piece.color == color then eval = eval + 1
        else eval = eval - 1 end
    end

    return eval
end

return BlindGreedBot
