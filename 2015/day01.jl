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

translated = @pipe read_input() |>
    first |>
    collect |>
    map(x -> translation[x], _)

@pipe translated |>
    sum |>
    print("Part one: ", _, "\n")

@pipe translated |>
    cumsum |>
    .==(_, -1) |>
    findall |>
    first |>
    print("Part two: ", _, "\n")
