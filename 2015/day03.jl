using Pipe: @pipe
using DataStructures: DefaultDict, counter

include("../utils.jl")
using .Utils: read_input

moves = Dict('>' => [0, 1], '^' => [1, 0], 'v' => [-1, 0], '<' => [0, -1])

move_sequence = @pipe read_input(@__FILE__) |>
    first |>
    collect |>
    map(x -> moves[x], _) |>
    vcat([[0, 0]], _)

@pipe move_sequence |>
    accumulate(+, _) |>
    counter |>
    length |>
    print("Part one: ", _, "\n")

@pipe move_sequence |>
    (_[1:2:end], _[2:2:end]) |>
    map(a -> accumulate(+, a), _) |>
    map(counter, _) |>
    map(keys, _) |>
    map(Set, _) |>
    union(_...) |>
    length |>
    print("Part two: ", _, "\n")
