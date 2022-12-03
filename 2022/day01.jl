using Pipe: @pipe

@pipe identity(@__FILE__) |>
    joinpath(dirname(_), "input", first(splitext(basename(_))) * ".txt") |>
    read(_, String) |>
    strip |>
    split(_, r"\n{2}") |>
    map(s -> split.(s, r"\n"), _) |>
    map(l -> parse.(Int64, l), _) |>
    sum.(_) |>
    maximum |>
    println("Part 1: $_")

@pipe identity(@__FILE__) |>
    joinpath(dirname(_), "input", first(splitext(basename(_))) * ".txt") |>
    read(_, String) |>
    strip |>
    split(_, r"\n{2}") |>
    map(s -> split.(s, r"\n"), _) |>
    map(l -> parse.(Int64, l), _) |>
    sum.(_) |>
    sort(_, rev=true) |>
    _[begin:3] |>
    sum |>
    println("Part 2: $_")
