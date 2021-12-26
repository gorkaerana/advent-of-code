using Pipe: @pipe
using Statistics: median

delimiters = Dict(
    '(' => ')',
    '[' => ']',
    '{' => '}',
    '<' => '>'
)
inv_delimiters = Dict(val => key for (key, val) in delimiters)
opening_delimiters = keys(delimiters)
closing_delimiters = values(delimiters)

illegal_character_scores = Dict(
    ')' => 3,
    ']' => 57,
    '}' => 1197,
    '>' => 25137
)
closing_delimiter_scores = Dict(
    ')' => 1,
    ']' => 2,
    '}' => 3,
    '>' => 4
)

function line_state(line)
    openings = []
    for char in line
        if char in opening_delimiters
            push!(openings, char)
        elseif char in closing_delimiters
            if pop!(openings) != inv_delimiters[char]
                return ("corrupted", char)
            end
        else
            error("Neither an opening nor a closing delimiter")
        end
    end
    if length(openings) == 0
        return ("normal", nothing)
    end
    return @pipe openings |>
        reverse(_) |>
        map(c -> delimiters[c], _) |>
        ("incomplete", _)
end

function autocomplete_score(closing_characters)
    score = 0
    for char in closing_characters
        score *= 5
        score += closing_delimiter_scores[char]
    end
    score
end

@pipe joinpath(@__DIR__, "input", "day10.txt") |>
    readlines(_) |>
    line_state.(_) |>
    filter(p -> p[1] == "corrupted", _) |>
    map(p -> p[2], _) |>
    map(c -> illegal_character_scores[c], _) |>
    sum(_) |>
    print("Part 1: ", _, "\n")

@pipe joinpath(@__DIR__, "input", "day10.txt") |>
    readlines(_) |>
    line_state.(_) |>
    filter(p -> p[1] == "incomplete", _) |>
    map(p -> p[2], _) |>
    join.(_, "") |>
    autocomplete_score.(_) |>
    median(_) |>
    Int(_) |>
    print("Part 2: ", _, "\n")
