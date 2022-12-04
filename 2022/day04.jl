using Pipe: @pipe

function vector_to_range_set(v::Vector{SubString{String}})
    @pipe parse.(Int64, v) |> range(_...) |> Set
end

function fully_contained(v::Vector{Set{Int64}})
    s1, s2 = v
    issubset(s1, s2) || issubset(s2, s1)
end

function there_is_overlap(v::Vector{Set{Int64}})
    s1, s2 = v
    length(intersect(s1, s2)) > 0
end


@pipe identity(@__FILE__) |>
    joinpath(dirname(_), "input", first(splitext(basename(_))) * ".txt") |>
    readlines |>
    split.(_, ",") |>
    map(t -> split.(t, "-"), _) |>
    map(t -> vector_to_range_set.(t), _) |>
    map(t -> fully_contained(t), _) |>
    sum |>
    println("Part 1: $_")

@pipe identity(@__FILE__) |>
    joinpath(dirname(_), "input", first(splitext(basename(_))) * ".txt") |>
    readlines |>
    split.(_, ",") |>
    map(t -> split.(t, "-"), _) |>
    map(t -> vector_to_range_set.(t), _) |>
    map(t -> there_is_overlap(t), _) |>
    sum |>
    println("Part 2: $_")
