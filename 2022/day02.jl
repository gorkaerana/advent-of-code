using Pipe: @pipe

struct Rock end
struct Paper end
struct Scissors end

Shapes = Union{Rock,Paper,Scissors}

function >(x::Shapes, y::Shapes)
    # paper > rock
    (typeof(x) == Paper) && (typeof(y) == Rock) && return true
    # rock > scissors
    (typeof(x) == Rock) && (typeof(y) == Scissors) && return true
    # scissors > paper
    (typeof(x) == Scissors) && (typeof(y) == Paper) && return true
    false
end

function <(x::Shapes, y::Shapes)
    y > x
end

function Base.:(==)(x::Shapes, y::Shapes)
    typeof(x) == typeof(y)
end

foe_shape_map = Dict("A" => Rock(), "B" => Paper(), "C" => Scissors())
own_shape_map = Dict("X" => Rock(), "Y" => Paper(), "Z" => Scissors())
shape_score_map = Dict(Rock() => 1, Paper() => 2, Scissors() => 3)

function score1(foe_play::SubString, own_play::SubString)
    foe = foe_shape_map[foe_play]
    own = own_shape_map[own_play]
    outcome_score = nothing
    if foe == own
        outcome_score = 3
    elseif foe > own
        outcome_score = 0
    elseif foe < own
        outcome_score = 6
    end
    outcome_score + shape_score_map[own]
end

result_map = Dict("X" => >, "Y" => ==, "Z" => <)
outcome_score_map = Dict("X" => 0, "Y" => 3, "Z" => 6)

function score2(foe_play::SubString, result::SubString)
    foe = foe_shape_map[foe_play]
    comparator = result_map[result]
    choice = @pipe [Rock(), Paper(), Scissors()] |>
        filter(shape -> comparator(foe, shape), _) |>
        first
    outcome_score_map[result] + shape_score_map[choice]
end

@pipe identity(@__FILE__) |>
    joinpath(dirname(_), "input", first(splitext(basename(_))) * ".txt") |>
    readlines |>
    split.(_, r" ") |>
    map(t -> score1(t[1], t[2]), _) |>
    sum |>
    println("Part 1: $_")

@pipe identity(@__FILE__) |>
    joinpath(dirname(_), "input", first(splitext(basename(_))) * ".txt") |>
    readlines |>
    split.(_, r" ") |>
    map(t -> score2(t[1], t[2]), _) |>
    sum |>
    println("Part 2: $_")
