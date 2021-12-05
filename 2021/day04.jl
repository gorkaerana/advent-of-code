using Pipe: @pipe

input = @pipe dirname(@__FILE__) |>
    joinpath(_, "input", "day04.txt") |>
    readlines(_)
draws = parse.(Int, split(input[1], ","))
cards = zeros(100, 5, 5)
for (i, line_no) in enumerate(3:6:length(input))
    card = split.(input[line_no:line_no+4], r"\s+")
    for (j, row) in enumerate(card)
        # "15  9" splits into "15", "", "9"
        numbers = filter(r -> r != "", row)
        cards[i, j, :] = parse.(Int, numbers)
    end
end

function is_bingo_card(arr, dims)
    sums = sum(arr, dims=dims)
    return sums, sum(sums .== 5) != 0
end

function winning_card_no(sums)
    argmax(sums)[1]
end

function card_score(cards, matches, sums, draw)
    winning_card_idx = winning_card_no(sums)
    winning_card = cards[winning_card_idx, :, :]
    unmatched_mask = .!Bool.(matches[winning_card_idx, :, :])
    return sum(winning_card[unmatched_mask]) * draw
end

matches = zeros(100, 5, 5)
for (idx, draw) in enumerate(draws)
    global matches
    matches = matches + (cards .== draw)
    vertical_sums, vertical_match = is_bingo_card(matches, 2)
    horizontal_sums, horizontal_match = is_bingo_card(matches, 3)
    # Part 1
    if vertical_match
        score = card_score(cards, matches, vertical_sums, draw)
        @show score
        break
    end
    if horizontal_match
        score = card_score(cards, matches, horizontal_sums, draw)
        @show score
        break
    end
    # Part 2
end
