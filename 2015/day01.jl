using Pipe: @pipe

include("../utils.jl")
using .Utils: read_input

translation = Dict('(' => 1, ')' => -1)

translated = @pipe read_input(@__FILE__) |>
    first |>
    collect |>
    map(x -> translation[x], _)

@pipe translated |>
    sum |>
    print("Part one: ", _, "\n")

@pipe translated |>
    cumsum |>
    .==(_, -1) |>
    findall |>
    first |>
    print("Part two: ", _, "\n")
