struct Game
    id::Int
    draws::Vector{Dict{String, Int}}
end

function game_from_line(line::String)::Game
    game_id_info, draws_info = split(line, ": ")
    game_id = parse(Int, split(game_id_info, " ")[end])
    draws = [Dict{String, Int}(split(d, " ")[end] => parse(Int, split(d, " ")[begin]) for d in split(draw, ", ")) for draw in split(draws_info, "; ")]
    Game(game_id, draws)
end

function is_game_possible(game::Game, bag::Dict{String, Int})::Bool
    for draw in game.draws
        any(n_cubes > bag[color] for (color, n_cubes) in draw) && return false
    end
    true
end

function fewest_cubes(game::Game)::Dict{String, Int}
    Dict(color => maximum(get(draw, color, 0) for draw in game.draws) for color in unique(v for draw in game.draws for v in keys(draw)))
end

power(cubes::Dict{String, Int}) = reduce(*, values(cubes))

# Part 1
bag = Dict("red" => 12, "green" => 13, "blue" => 14)
sum_of_ids = sum(game.id for game in map(game_from_line, readlines("day02.txt")) if is_game_possible(game, bag))
println("Part 1: $sum_of_ids")

# Part 2
sum_of_powers = sum(power(fewest_cubes(game_from_line(line))) for line in readlines("day02.txt"))
println("Part 1: $sum_of_powers")
