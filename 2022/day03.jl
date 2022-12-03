using IterTools: chain
using Pipe: @pipe

priority = Dict()

for (i, c) in enumerate(chain('a':'z', 'A':'Z'))
    priority[c] = i
end

function split_in_half(string::String)
    index = Integer(length(string) // 2)
    string[begin:index], string[(index + 1):end]
end

function character_intersection(strings)
    intersection = Set(strings[1])
    for s in strings[1:end]
        intersection = intersect(intersection, Set(s))
    end
    intersection
end

function nwise(iterator, n::Integer)
    l = length(iterator)
    [iterator[i:(i+n-1)] for i = 1:n:(l+1-n)]
end

@pipe identity(@__FILE__) |>
    joinpath(dirname(_), "input", first(splitext(basename(_))) * ".txt") |>
    readlines |>
    map(split_in_half, _) |>
    map(character_intersection, _) |>
    map(set -> sum(priority[e] for e in set), _) |>
    sum |>
    println("Part 1: $_")

@pipe identity(@__FILE__) |>
    joinpath(dirname(_), "input", first(splitext(basename(_))) * ".txt") |>
    readlines |>
    nwise(_, 3) |>
    map(character_intersection, _) |>
    map(set -> sum(priority[e] for e in set), _) |>
    sum |>
    println("Part 2: $_")
