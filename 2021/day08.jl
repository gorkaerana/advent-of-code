using Pipe: @pipe

input = @pipe joinpath(@__DIR__, "input", "day08.txt") |>
    readlines(_) |>
    split.(_, " | ") |>
    map(x -> x[2], _) |>
    split.(_, " ") |>
    map(l -> length.(l), _) |>
    vcat(_...) |>
    filter(x -> x in [2 4 3 7], _) |>
    length(_)

n_segments = Dict(
    0 => 6,
    1 => 2, #
    2 => 5,
    3 => 5,
    4 => 4, #
    5 => 5,
    6 => 6,
    7 => 3, #
    8 => 7, #
    9 => 6
)
@show input
