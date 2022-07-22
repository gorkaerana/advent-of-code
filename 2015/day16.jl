using Pipe: @pipe

include("../utils.jl")
using .Utils: read_input


function parse_aunt_memory(memory::String)
    @pipe memory |>
        split(_, r" ?: ?", limit=2) |>
        last |>
        split(_, r" ?, ?") |>
        split.(_, r" ?: ?") |>
        Dict
end


"""True aunty goes in the first argument"""
function range_compare_intersection(a1::Dict, a2::Dict)
    intersection = []
    for k in intersect(keys(a1), keys(a2))
        (v1, v2) = (a1[k], a2[k])
        if k ∈ ["cats", "trees"]
            if v1 < v2
                push!(intersection, k)
            end
        elseif k ∈ ["pomeranians", "goldfish"]
            if v1 > v2
                push!(intersection, k)
            end
        else
            if v1 == v2
                push!(intersection, k)
            end
        end
    end
    intersection
end


analysis_result = """children: 3
cats: 7
samoyeds: 2
pomeranians: 3
akitas: 0
vizslas: 0
goldfish: 5
trees: 3
cars: 2
perfumes: 1"""

true_aunty = @pipe analysis_result |>
    split(_, r"\n+") |>
    split.(_, r" ?: ?") |>
    Dict

@pipe read_input(@__FILE__) |>
    parse_aunt_memory.(_) |>
    map(a -> intersect(true_aunty, a), _) |>
    length.(_) |>
    findall(isequal(maximum(_)), _) |>
    first |>
    print("Part one: ", _, "\n")

@pipe read_input(@__FILE__) |>
    parse_aunt_memory.(_) |>
    map(a -> range_compare_intersection(true_aunty, a), _) |>
    length.(_) |>
    findall(isequal(maximum(_)), _) |>
    first |>
    print("Part two: ", _, "\n")
