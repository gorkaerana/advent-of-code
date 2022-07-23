using Pipe: @pipe
using Combinatorics

include("../utils.jl")
using .Utils: read_input


function container_combinations(containers::Vector{Int}, target::Int)
    [c for c in Combinatorics.combinations(containers) if sum(c) == target]
end

@pipe read_input(@__FILE__) |>
    parse.(Int, _) |>
    container_combinations(_, 150) |>
    length |>
    print("Part one: ", _, "\n")

@pipe read_input(@__FILE__) |>
    parse.(Int, _) |>
    container_combinations(_, 150) |>
    length.(_) |>
    findall(isequal(minimum(_)), _) |>
    length |>
    print("Part two: ", _, "\n")
