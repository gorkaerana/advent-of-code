module Utils

export read_input

using Pipe: @pipe

function read_input(filepath)
    # TODO: substitute with reading from webpage
    # Convention: input is in "input/$(filename).txt" where filename = a given
    # day's file name
    @pipe filepath |>
        splitpath |> 
        last |>
        split(_, ".") |>
        first |> 
        joinpath(dirname(filepath), "input", "$(_).txt") |>
        readlines
end

end
