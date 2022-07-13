using Pipe: @pipe

function read_input()
    # TODO: substitute with reading from webpage
    # Convention: input is in "input/$(filename).txt" where filename = a given
    # day's file name
    @pipe splitpath(@__FILE__) |> 
        last |>
        split(_, ".") |>
        first |> 
        joinpath(@__DIR__, "input", "$(_).txt") |>
        readlines
end

translation = Dict('(' => 1, ')' => -1)

@pipe read_input() |>
    first |>
    collect |>
    map(x -> translation[x], _) |>
    sum |>
    print("Part one: ", _, "\n")

@pipe read_input() |>
    first |>
    collect |>
    map(x -> translation[x], _) |>
    cumsum |>
    map(x -> x == -1, _) |>
    findall |>
    first |>
    print("Part two: ", _, "\n")
