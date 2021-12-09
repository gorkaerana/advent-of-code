using DataStructures: counter
using Pipe: @pipe

digit_segments = Dict(
    0 => "abcefg",
    1 => "cf",
    2 => "acdeg",
    3 => "acdfg",
    4 => "bcdf",
    5 => "abdfg",
    6 => "abdefg",
    7 => "acf",
    8 => "abcdefg",
    9 => "abcdfg"
)

non_repeated_n_segments = @pipe digit_segments |>
    values(_) |>
    length.(_) |>
    counter(_) |>
    filter(p -> last(p) == 1, _) |>
    keys(_)

function process_entry(string)
    signal_patterns, output_value = @pipe string |>
        split(_, " | ") |>
        split.(_, " ")
    return signal_patterns, output_value
end

input = @pipe joinpath(@__DIR__, "input", "day08.txt") |>
    readlines(_)

# part1 =  @pipe input |>
#     process_entry.(_) |>
#     map(entry -> getindex(entry, 2), _) |>
#     vcat(_...) |>
#     length.(_) |>
#     filter(x -> x in non_repeated_n_segments, _) |>
#     length(_)
# @show part1

# part2 = @pipe input |>
#     split.(_, " | ") |>
#     map(x -> getindex(x, 1), _) |>
#     split.(_, " ") |>
#     vcat(_...) |>
#     length.(_) |>
#     counter(_)
# @show part2
