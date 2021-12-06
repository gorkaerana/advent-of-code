using Pipe: @pipe

input = @pipe dirname(@__FILE__) |>
    joinpath(_, "input", "day04.txt") |>
    readlines(_)
draws = parse.(Int, split(input[1], ","))
cards = zeros(5, 5, 100)
for (i, line_no) in enumerate(3:6:length(input))
    card = @pipe input[line_no:line_no+4] |>
        strip.(_) |>
        split.(_, r"\s+")
    for (j, row) in enumerate(card)
        cards[j, :, i] = parse.(Int, row)
    end
end

function card_has_bingo(mask)
    for dims in 1:2
        if any(sum(mask, dims=dims) .== 5)
            return true
        end
    end
    return false
end

function card_score(card, mask, draw)
    sum(card .* (.!mask)) * draw
end

marked_mask = Bool.(zeros(5, 5, 100))
bingo_mask = Bool.(zeros(100))
first_bingo = true
score = 0
for (idx, draw) in enumerate(draws)
    global first_bingo, score
    marked_mask[:, :, :] += (cards .== draw)
    bingo_cards = card_has_bingo.(eachslice(marked_mask, dims=3))
    if sum(bingo_cards) > sum(bingo_mask)
        latest_bingo = bingo_mask[:] .⊻ bingo_cards[:]
        score = @pipe latest_bingo |>
            card_score(cards[:, :, _], marked_mask[:, :, _], draw)
        if first_bingo
            println("Part 1: the score of the first winning board is $(score).")
            first_bingo = false
        end
        bingo_mask[:] = bingo_mask[:] .| bingo_cards[:]
    end
end
println("Part 2: the score of the last winning board is $(score).")
