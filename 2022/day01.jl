using Pipe: @pipe

@pipe dirname(@__FILE__) |>
    join([_, "input", "day01.txt"], '/') |>
    read(_, String) |>
    strip |>
    split(_, r"\n{2}") |>
    map(s -> split.(s, r"\n"), _) |>
    map(l -> parse.(Int64, l), _) |>
    sum.(_) |>
    maximum |>
    println("Part 1: $_")

@pipe dirname(@__FILE__) |>
    join([_, "input", "day01.txt"], '/') |>
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
