struct Game
    number::Integer
    winning_numbers::Vector{Integer}
    your_numbers::Vector{Integer}
end

function game_from_line(line::String)::Game
    game_number, cards = split(line, ": ")
    winning_numbers, your_numbers = split(cards, " | ")
    Game(
        parse(Int, split(game_number)[end]),
        parse.(Int, split(winning_numbers)),
        parse.(Int, split(your_numbers)),
    )
end

function number_of_winning_numbers(game::Game)::Integer
    winning_numbers = Set(game.winning_numbers)
    sum((number in winning_numbers) for number = game.your_numbers)
end

function points(game::Game)::Integer
    n_winning_numbers = number_of_winning_numbers(game)
    (n_winning_numbers == 0) ? 0 : 2 ^ (n_winning_numbers - 1)
end

function count_scratchcards_with_rules(games::Vector{Game})::Dict{Integer, Integer}
    scratchcard_counter::Dict{Integer, Integer} = Dict()
    for game = games
        i = game.number
        scratchcard_counter[i] = get(scratchcard_counter, i, 0) + 1
        for j = (i + 1):(i + number_of_winning_numbers(game))
            scratchcard_counter[j] = get(scratchcard_counter, j, 0) + scratchcard_counter[i]
        end
    end    
    scratchcard_counter
end

# Part 1
lines = readlines("day04.txt")
games = game_from_line.(lines)
total_points = sum(points.(games))
println("Part 1: $total_points")

# Part 2
total_scratchcards = sum(values(count_scratchcards_with_rules(games)))
println("Part 2: $total_scratchcards")
